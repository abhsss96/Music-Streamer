require "rails_helper"

RSpec.describe "Follows", type: :request do
  let(:user) { create(:user) }
  let(:artist) { create(:artist) }

  describe "POST /api/v1/artists/:id/follow" do
    it "requires authentication" do
      post "/api/v1/artists/#{artist.id}/follow"
      expect(response).to have_http_status(:unauthorized)
    end

    it "follows an artist" do
      post "/api/v1/artists/#{artist.id}/follow", headers: auth_headers(user)

      expect(response).to have_http_status(:created)
      expect(user.followed_artists).to include(artist)
    end

    it "rejects following the same artist twice" do
      create(:follow, user: user, artist: artist)

      post "/api/v1/artists/#{artist.id}/follow", headers: auth_headers(user)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /api/v1/artists/:id/follow" do
    it "unfollows an artist" do
      create(:follow, user: user, artist: artist)

      delete "/api/v1/artists/#{artist.id}/follow", headers: auth_headers(user)

      expect(response).to have_http_status(:no_content)
      expect(user.followed_artists.reload).not_to include(artist)
    end

    it "is idempotent when not following" do
      delete "/api/v1/artists/#{artist.id}/follow", headers: auth_headers(user)
      expect(response).to have_http_status(:no_content)
    end
  end
end
