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

  def sigup registration, status = :ok
    jpost user_registration_path, registration
    expect(response).to have_http_status(status)
  end
end
