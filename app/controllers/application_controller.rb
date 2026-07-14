class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable

  private

  def render_forbidden
    render json: { error: "You are not authorized to perform this action" }, status: :forbidden
  end

  def render_not_found
    render json: { error: "Not found" }, status: :not_found
  end

  def render_unprocessable(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_content
  end
end
