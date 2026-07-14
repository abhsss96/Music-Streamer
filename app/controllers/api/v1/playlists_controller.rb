module Api
  module V1
    class PlaylistsController < BaseController
      def index
        render json: policy_scope(Playlist).order(:name)
      end

      def show
        playlist = Playlist.find(params[:id])
        authorize playlist
        render json: playlist.as_json(include: { playlist_tracks: { include: :track } })
      end

      def create
        playlist = current_user.playlists.new(playlist_params)
        authorize playlist

        if playlist.save
          render json: playlist, status: :created
        else
          render json: { errors: playlist.errors.full_messages }, status: :unprocessable_content
        end
      end

      def update
        playlist = Playlist.find(params[:id])
        authorize playlist

        if playlist.update(playlist_params)
          render json: playlist
        else
          render json: { errors: playlist.errors.full_messages }, status: :unprocessable_content
        end
      end

      def destroy
        playlist = Playlist.find(params[:id])
        authorize playlist
        playlist.destroy
        head :no_content
      end

      private

      def playlist_params
        params.require(:playlist).permit(:name)
      end
    end
  end
end
