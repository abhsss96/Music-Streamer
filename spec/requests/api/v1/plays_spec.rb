require "rails_helper"

RSpec.describe "Plays", type: :request, stub_s3_env: true do
  let(:user) { create(:user) }
  let(:track) { create(:track, audio_object_key: "artists/1/tracks/1.mp3") }

  describe "POST /api/v1/tracks/:id/play" do
    it "requires authentication" do
      post "/api/v1/tracks/#{track.id}/play"
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a short-lived signed URL and never the audio bytes" do
      post "/api/v1/tracks/#{track.id}/play", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["url"]).to include(track.audio_object_key)
      expect(json_response["expires_in"]).to eq(300)
      expect(response.content_type).to include("application/json")
    end

    it "404s for a missing track" do
      post "/api/v1/tracks/999999/play", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end
end
