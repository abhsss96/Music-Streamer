module Api
  module V1
    class FollowsController < BaseController
      def create
        follow = current_user.follows.new(artist: artist)

        if follow.save
          render json: follow, status: :created
        else
          render json: { errors: follow.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        current_user.follows.find_by(artist: artist)&.destroy
        head :no_content
      end

      private

      def artist
        @artist ||= Artist.find(params[:id])
      end
    end
  end
end
