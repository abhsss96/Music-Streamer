require "rails_helper"

RSpec.describe "Albums", type: :request do
  let(:user) { create(:user) }

  describe "GET /api/v1/albums" do
    it "requires authentication" do
      get "/api/v1/albums"
      expect(response).to have_http_status(:unauthorized)
    end

    it "lists albums" do
      create_list(:album, 2)

      get "/api/v1/albums", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["data"].size).to eq(2)
      expect(json_response["meta"]["total_count"]).to eq(2)
    end

    it "paginates results" do
      create_list(:album, 3)

      get "/api/v1/albums", params: { per_page: 2 }, headers: auth_headers(user)

      expect(json_response["data"].size).to eq(2)
      expect(json_response["meta"]).to eq(
        "page" => 1, "per_page" => 2, "total_count" => 3, "total_pages" => 2
      )
    end
  end

  describe "GET /api/v1/albums/:id" do
    it "shows an album" do
      album = create(:album)

      get "/api/v1/albums/#{album.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(album.id)
    end

    it "404s for a missing album" do
      get "/api/v1/albums/999999", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end
end
