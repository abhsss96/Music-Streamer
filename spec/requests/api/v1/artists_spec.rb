require "rails_helper"

RSpec.describe "Artists", type: :request do
  let(:user) { create(:user) }

  describe "GET /api/v1/artists" do
    it "requires authentication" do
      get "/api/v1/artists"
      expect(response).to have_http_status(:unauthorized)
    end

    it "lists artists" do
      create_list(:artist, 3)

      get "/api/v1/artists", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(3)
    end
  end

  describe "GET /api/v1/artists/:id" do
    it "shows an artist" do
      artist = create(:artist)

      get "/api/v1/artists/#{artist.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(artist.id)
    end

    it "404s for a missing artist" do
      get "/api/v1/artists/999999", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end
end
