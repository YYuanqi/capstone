module ApiHelper
  ["post", "get", "delete"].each do |http_method_name|
    define_method("j#{http_method_name}") do |path, params = {}, headers = {}|
      if ["post", "delete"].include? http_method_name
        headers = headers.merge("content-type" => 'application/json') if !params.empty?
        params = params.to_json
      end
      self.send(http_method_name, path,
                params: params,
                headers: headers.merge(access_tokens))
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end

  def signup registration, status = :ok
    jpost user_registration_path, registration
    expect(response).to have_http_status(status)
    payload = parsed_body
    if response.ok?
      registration.merge(:id => payload["data"]["id"],
                         :uid => payload["data"]["uid"])
    end
  end

  def login credentials,  status = :ok
    jpost user_session_path, credentials.slice(:email, :password)
    expect(response).to have_http_status(status)
    return response.ok? ? parsed_body["data"] : parsed_body
  end

  def logout status = :ok
    jdelete destroy_user_session_path
    @last_tokens = {}
    expect(response).to have_http_status(status)
  end

  def access_tokens
    if access_tokens?
      @last_tokens = ["uid", "client", "token-type", "access-token"].inject({}) {|h, k| h[k] = response.headers[k]; h}
    end
    @last_tokens || {}
  end

  def access_tokens?
    !response.headers["access-token"].nil? if response
  end
end

Rspec.shared_examples "show resource" 
