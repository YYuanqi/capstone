class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def record_not_found(exception)
    full_message_error "can not find id[#{params[:id]}]", :not_found
    Rails.logger.debug exception.message
  end

  def full_message_error full_message, status
    payload = {
        errors: { full_message: full_message }
    }

    render :json => payload, :status => status
  end
end
