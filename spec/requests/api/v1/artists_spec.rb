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
      expect(json_response["data"].size).to eq(3)
      expect(json_response["meta"]).to eq(
        "page" => 1, "per_page" => 25, "total_count" => 3, "total_pages" => 1
      )
    end

    it "paginates results" do
      create_list(:artist, 5)

      get "/api/v1/artists", params: { per_page: 2 }, headers: auth_headers(user)
      expect(json_response["data"].size).to eq(2)
      expect(json_response["meta"]).to eq(
        "page" => 1, "per_page" => 2, "total_count" => 5, "total_pages" => 3
      )

      get "/api/v1/artists", params: { page: 2, per_page: 2 }, headers: auth_headers(user)
      expect(json_response["data"].size).to eq(2)
      expect(json_response["meta"]["page"]).to eq(2)

      get "/api/v1/artists", params: { page: 3, per_page: 2 }, headers: auth_headers(user)
      expect(json_response["data"].size).to eq(1)
    end

    it "returns an empty data array for an out-of-range page" do
      create_list(:artist, 2)

      get "/api/v1/artists", params: { page: 99 }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["data"]).to eq([])
    end

    it "caps per_page at the configured maximum" do
      create_list(:artist, 3)

      get "/api/v1/artists", params: { per_page: 1000 }, headers: auth_headers(user)

      expect(json_response["meta"]["per_page"]).to eq(Paginatable::MAX_PER_PAGE)
    end

    it "searches by name when q is present" do
      create(:artist, name: "Componibile Sunrise")
      create(:artist, name: "Marlowe & The Tin Cans")

      get "/api/v1/artists", params: { q: "sunrise" }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["data"].map { |a| a["name"] }).to eq([ "Componibile Sunrise" ])
    end

    it "returns an empty result for a non-matching search" do
      create(:artist, name: "Componibile Sunrise")

      get "/api/v1/artists", params: { q: "zzzznotfound" }, headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["data"]).to eq([])
      expect(json_response["meta"]["total_count"]).to eq(0)
    end

    it "paginates search results" do
      create(:artist, name: "Sunrise One")
      create(:artist, name: "Sunrise Two")
      create(:artist, name: "Sunrise Three")

      get "/api/v1/artists", params: { q: "sunrise", per_page: 2 }, headers: auth_headers(user)

      expect(json_response["data"].size).to eq(2)
      expect(json_response["meta"]).to include("total_count" => 3, "total_pages" => 2)
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
