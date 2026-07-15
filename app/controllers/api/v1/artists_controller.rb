module Api
  module V1
    class ArtistsController < BaseController
      def index
        scope = params[:q].present? ? Artist.search(params[:q]) : Artist.order(:name)
        render json: paginate(scope)
      end

      def show
        render json: Artist.find(params[:id])
      end
    end
  end
end
