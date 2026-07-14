require "rails_helper"

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:track) { create(:track) }

  describe "POST /api/v1/tracks/:id/like" do
    it "requires authentication" do
      post "/api/v1/tracks/#{track.id}/like"
      expect(response).to have_http_status(:unauthorized)
    end

    it "likes a track" do
      post "/api/v1/tracks/#{track.id}/like", headers: auth_headers(user)

      expect(response).to have_http_status(:created)
      expect(user.liked_tracks).to include(track)
    end

    it "rejects liking the same track twice" do
      create(:like, user: user, track: track)

      post "/api/v1/tracks/#{track.id}/like", headers: auth_headers(user)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /api/v1/tracks/:id/like" do
    it "unlikes a track" do
      create(:like, user: user, track: track)

      delete "/api/v1/tracks/#{track.id}/like", headers: auth_headers(user)

      expect(response).to have_http_status(:no_content)
      expect(user.liked_tracks.reload).not_to include(track)
    end

    it "is idempotent when not liked" do
      delete "/api/v1/tracks/#{track.id}/like", headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end
  end
end
