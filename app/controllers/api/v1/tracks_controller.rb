module Api
  module V1
    class TracksController < BaseController
      def index
        render json: Track.includes(:artist, :album).order(:title)
      end

      def show
        render json: Track.find(params[:id])
      end
    end
  end
end
