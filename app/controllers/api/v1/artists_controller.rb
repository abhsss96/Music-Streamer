module Api
  module V1
    class ArtistsController < BaseController
      def index
        render json: paginate(Artist.order(:name))
      end

      def show
        render json: Artist.find(params[:id])
      end
    end
  end
end
