require "rails_helper"

RSpec.describe "API authentication", type: :request do
  describe "requests to a protected endpoint" do
    it "rejects a missing Authorization header" do
      get "/api/v1/artists"
      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects a malformed Authorization header" do
      get "/api/v1/artists", headers: { "Authorization" => "garbage" }
      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects a tampered token" do
      token = JsonWebToken.encode({ user_id: create(:user).id })
      get "/api/v1/artists", headers: { "Authorization" => "Bearer #{token}x" }
      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects a token for a deleted user" do
      user = create(:user)
      token = JsonWebToken.encode({ user_id: user.id })
      user.destroy

      get "/api/v1/artists", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
