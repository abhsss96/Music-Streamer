module Api
  module V1
    class PlaylistTracksController < BaseController
      # Add a track to a playlist. Appends to the end unless `position` is given.
      def create
        authorize playlist, :manage_tracks?

        playlist_track = playlist.playlist_tracks.new(track_id: params[:track_id])

        if playlist_track.save
          playlist_track.insert_at(params[:position].to_i) if params[:position].present?
          render json: playlist_track.reload.as_json(include: :track), status: :created
        else
          render json: { errors: playlist_track.errors.full_messages }, status: :unprocessable_content
        end
      end

      # Reorder a track within a playlist.
      def update
        authorize playlist, :manage_tracks?

        playlist_track = playlist.playlist_tracks.find(params[:id])
        playlist_track.insert_at(reorder_params[:position].to_i)
        render json: playlist_track.reload.as_json(include: :track)
      end

      # Remove a track from a playlist.
      def destroy
        authorize playlist, :manage_tracks?

        playlist.playlist_tracks.find(params[:id]).destroy
        head :no_content
      end

      private

      def playlist
        @playlist ||= Playlist.find(params[:playlist_id])
      end

      def reorder_params
        params.permit(:position)
      end
    end
  end
end
