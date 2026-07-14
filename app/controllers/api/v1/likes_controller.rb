module Api
  module V1
    class LikesController < BaseController
      def create
        like = current_user.likes.new(track: track)

        if like.save
          render json: like, status: :created
        else
          render json: { errors: like.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        current_user.likes.find_by(track: track)&.destroy
        head :no_content
      end

      private

      def track
        @track ||= Track.find(params[:id])
      end
    end
  end
end
