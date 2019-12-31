module ApiHelper
  %w[head get post put patch delete].each do |http_method_name|
    define_method("j#{http_method_name}") do |path, params = {}, headers = {}|
      if %w[post put patch].include? http_method_name
        headers = headers.merge('content-type' => 'application/json') unless params.empty?
        params = params.to_json
      end
      send(http_method_name,
           path,
           params: params,
           headers: headers.merge(access_tokens))
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end

  def signup(registration, status = :ok)
    jpost user_registration_path, registration
    expect(response).to have_http_status(status)
    payload = parsed_body
    if response.ok?
      registration.merge(id: payload['data']['id'],
                         uid: payload['data']['uid'])
    end
  end

  def login(credentials, status = :ok)
    jpost user_session_path, credentials.slice(:email, :password)
    expect(response).to have_http_status(status)
    response.ok? ? parsed_body['data'] : parsed_body
  end

  def logout(status = :ok)
    jdelete destroy_user_session_path
    @last_tokens = {}
    expect(response).to have_http_status(status) if status
  end

  def access_tokens
    if access_tokens?
      @last_tokens = %w[uid client token-type access-token].each_with_object({}) { |k, h| h[k] = response.headers[k]; }
    end
    @last_tokens || {}
  end

  def access_tokens?
    !response.headers['access-token'].nil? if response
  end

  def create_resource path, factory, status = :created
    jpost path, FactoryBot.attributes_for(factory)
    expect(response).to have_http_status(status) if status
    parsed_body
  end

  def apply_admin account
    User.find(account[:id]).roles.create(role_name: Role::ADMIN)
    account
  end

  def apply_originator account, model_class
    User.find(account[:id]).add_role(Role::ORIGINATOR, model_class).save
    account
  end

  def apply_role account, role, object
    user = User.find(account[:id])
    arr = object.kind_of?(Array) ? object : [object]
    arr.each do |m|
      user.add_role(role, m).save
    end
    account
  end

  def apply_organizer account, object
    apply_role(account, Role::ORGANIZER, object)
  end

  def apply_member account, object
    apply_role(account, Role::MEMBER, object)
  end
end

RSpec.shared_examples 'show resource' do |model|
  let(:resource) { FactoryBot.create(model) }
  let(:payload) { parsed_body }
  let(:bad_id) { 1_234_567_890 }

  it "returns #{model.capitalize} when using correct ID" do
    jget send("#{model}_path", resource.id), {}, 'Accept' => 'application/json'
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
  end
end

RSpec.shared_examples 'create resource' do |model|
  let(:resource_state) { FactoryBot.attributes_for(model) }
  let(:payload) { parsed_body }
  let(:resource_id) { payload['id'] }

  it "can create valid #{model}" do
    jpost send("#{model}s_path"), resource_state
    expect(response).to have_http_status(:created)
    expect(response.content_type).to eq('application/json')
    expect(payload).to have_key('id')
    jget send("#{model}_path", resource_id)
    expect(response).to have_http_status(:ok)
  end
end

RSpec.shared_examples 'resource index' do |model|
  let!(:resources) { (1..5).map { FactoryBot.create(model) } }
  let(:payload) { parsed_body }

  it "return all #{model} instance" do
    jget send("#{model}s_path"), {}, 'Accept' => 'application/json'
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(payload.count).to eq(resources.count)
  end
end

RSpec.shared_examples 'modifiable resource' do |model|
  let(:resource) do
    jpost send("#{model}s_path"), FactoryBot.attributes_for(model)
    expect(response).to have_http_status(:created)
    parsed_body
  end
  let(:new_state) { FactoryBot.attributes_for(model) }

  it "can update #{model}" do
    jput send("#{model}_path", resource['id']), new_state
    expect(response).to have_http_status(:no_content)
  end

  it 'can be deleted' do
    jhead send("#{model}_path", resource['id'])
    expect(response).to have_http_status(:ok)

    jdelete send("#{model}_path", resource['id'])
    expect(response).to have_http_status(:no_content)

    jhead send("#{model}_path", resource['id'])
    expect(response).to have_http_status(:not_found)
  end
end
