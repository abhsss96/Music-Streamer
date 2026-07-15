require "rails_helper"

RSpec.describe "Tracks", type: :request do
  let(:user) { create(:user) }

  describe "GET /api/v1/tracks" do
    it "requires authentication" do
      get "/api/v1/tracks"
      expect(response).to have_http_status(:unauthorized)
    end

    it "lists tracks" do
      create_list(:track, 2)

      get "/api/v1/tracks", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["data"].size).to eq(2)
      expect(json_response["meta"]["total_count"]).to eq(2)
    end

    it "paginates results" do
      create_list(:track, 3)

      get "/api/v1/tracks", params: { per_page: 2 }, headers: auth_headers(user)

      expect(json_response["data"].size).to eq(2)
      expect(json_response["meta"]).to eq(
        "page" => 1, "per_page" => 2, "total_count" => 3, "total_pages" => 2
      )
    end
  end

  describe "GET /api/v1/tracks/:id" do
    it "shows a track, including license and attribution" do
      track = create(:track, license_type: "cc-by", attribution_text: "By Some Artist")

      get "/api/v1/tracks/#{track.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(json_response["license_type"]).to eq("cc-by")
      expect(json_response["attribution_text"]).to eq("By Some Artist")
    end

    it "404s for a missing track" do
      get "/api/v1/tracks/999999", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end
end
