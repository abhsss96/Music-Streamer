require "rails_helper"

RSpec.describe "Playlists", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /api/v1/playlists" do
    it "requires authentication" do
      get "/api/v1/playlists"
      expect(response).to have_http_status(:unauthorized)
    end

    it "only lists the current user's playlists" do
      create(:playlist, user: user, name: "Mine")
      create(:playlist, user: other_user, name: "Not mine")

      get "/api/v1/playlists", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response.map { |p| p["name"] }).to eq([ "Mine" ])
    end
  end

  describe "GET /api/v1/playlists/:id" do
    it "shows the current user's own playlist" do
      playlist = create(:playlist, user: user)

      get "/api/v1/playlists/#{playlist.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(playlist.id)
    end

    it "forbids viewing another user's playlist" do
      playlist = create(:playlist, user: other_user)

      get "/api/v1/playlists/#{playlist.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /api/v1/playlists" do
    it "creates a playlist owned by the current user" do
      post "/api/v1/playlists", params: { playlist: { name: "Road Trip" } }, headers: auth_headers(user)

      expect(response).to have_http_status(:created)
      expect(json_response["user_id"]).to eq(user.id)
    end

    it "rejects an invalid playlist" do
      post "/api/v1/playlists", params: { playlist: { name: "" } }, headers: auth_headers(user)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /api/v1/playlists/:id" do
    it "updates the current user's own playlist" do
      playlist = create(:playlist, user: user, name: "Old name")

      patch "/api/v1/playlists/#{playlist.id}", params: { playlist: { name: "New name" } }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(playlist.reload.name).to eq("New name")
    end

    it "forbids updating another user's playlist" do
      playlist = create(:playlist, user: other_user, name: "Old name")

      patch "/api/v1/playlists/#{playlist.id}", params: { playlist: { name: "New name" } }, headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
      expect(playlist.reload.name).to eq("Old name")
    end
  end

  describe "DELETE /api/v1/playlists/:id" do
    it "destroys the current user's own playlist" do
      playlist = create(:playlist, user: user)

      delete "/api/v1/playlists/#{playlist.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:no_content)
      expect(Playlist.exists?(playlist.id)).to be false
    end

    it "forbids destroying another user's playlist" do
      playlist = create(:playlist, user: other_user)

      delete "/api/v1/playlists/#{playlist.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
      expect(Playlist.exists?(playlist.id)).to be true
    end
  end
end
