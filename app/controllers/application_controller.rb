class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :missing_parameter
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Mongoid::Errors::Validations, with: :mongoid_validate_error


  protected

    def full_message_error(full_message, status)
      payload = {
        errors: {full_messages: full_message}
      }
      render json: payload, status: status
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    def record_not_found(exception)
      full_message_error "can not find id[#{params[:id]}]", :not_found
      Rails.logger.debug exception.message
    end

    def missing_parameter(exception)
      full_message_error exception.message, :bad_request
      Rails.logger.debug exception.message
    end

    def user_not_authorized(exception)
      user = pundit_user ? pundit_user.uid : "Anonymous user"
      full_message_error "#{user} not authorized to #{exception.query}", :forbidden
      Rails.logger.debug exception.message
    end

    def mongoid_validate_error(exception)
      full_message_error exception.record.errors.messages, :unprocessable_entity
      Rails.logger.debug exception.message
    end
end
