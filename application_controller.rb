#app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  ...

  def respond_with_service(result)
    if result.success?
      render json: result.object, status: :ok
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end
end