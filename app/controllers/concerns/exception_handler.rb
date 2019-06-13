module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

   # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_request
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_entity_request
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_entity_request
    
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response( {message: e.message }, :not_found )
    end

  end

   # JSON response with message and status code 422 - Unprocessable entity
  def unprocessable_entity_request(e)
    json_response( { message: e.message }, :unprocessable_entity)
  end

   # JSON response with message and status code 401 - Unauthorized
  def unauthorized_request(e)
    json_response( { message: e.message }, :unauthorized)
  end
end
