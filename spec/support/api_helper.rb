module ApiHelper
  ["post"].each do |http_method_name|
    define_method("j#{http_method_name}") do |path, params = {}, headers = {}|
      headers = headers.merge("content-type" => 'application/json') if !params.empty?
      self.send(http_method_name, path, params: params.to_json, headers: headers)
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
end
