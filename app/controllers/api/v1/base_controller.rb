module Api
  module V1
    class BaseController < ApplicationController
      include Paginatable

      before_action :authenticate_user!

      private

      def authenticate_user!
        render_unauthorized and return unless current_user
      end

      def current_user
        @current_user ||= user_from_token
      end

      def user_from_token
        token = bearer_token
        return nil unless token

        payload = JsonWebToken.decode(token)
        User.find_by(id: payload[:user_id])
      rescue JsonWebToken::DecodeError
        nil
      end

      def bearer_token
        header = request.headers["Authorization"]
        header.split(" ").last if header&.start_with?("Bearer ")
      end

      def render_unauthorized
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
