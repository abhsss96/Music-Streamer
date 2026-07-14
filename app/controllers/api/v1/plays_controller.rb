module Api
  module V1
    class PlaysController < BaseController
      def create
        track = Track.find(params[:id])
        url = AudioUrlSigner.call(track.audio_object_key)

        render json: { url: url, expires_in: AudioUrlSigner::DEFAULT_EXPIRY.to_i }, status: :ok
      end
    end
  end
end
