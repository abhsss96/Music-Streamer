module Api
  module V1
    class AlbumsController < BaseController
      def index
        render json: Album.includes(:artist).order(:title)
      end

      def show
        render json: Album.find(params[:id])
      end
    end
  end
end
