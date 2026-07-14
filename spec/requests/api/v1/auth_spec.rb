require "rails_helper"

RSpec.describe "Auth", type: :request do
  describe "POST /api/v1/signup" do
    it "creates a user and returns a token" do
      post "/api/v1/signup", params: { user: { email: "new@example.com", password: "password123" } }

      expect(response).to have_http_status(:created)
      expect(json_response["user"]["email"]).to eq("new@example.com")
      expect(json_response["token"]).to be_present
      expect(json_response["user"]).not_to have_key("password_digest")
    end

    it "rejects invalid signups" do
      post "/api/v1/signup", params: { user: { email: "not-an-email", password: "short" } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end

    it "rejects duplicate emails" do
      create(:user, email: "taken@example.com")

      post "/api/v1/signup", params: { user: { email: "taken@example.com", password: "password123" } }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "POST /api/v1/login" do
    let!(:user) { create(:user, email: "demo@example.com", password: "password123") }

    it "returns a token for valid credentials" do
      post "/api/v1/login", params: { session: { email: "demo@example.com", password: "password123" } }

      expect(response).to have_http_status(:ok)
      expect(json_response["token"]).to be_present
    end

    it "rejects invalid credentials" do
      post "/api/v1/login", params: { session: { email: "demo@example.com", password: "wrong" } }

      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects unknown emails" do
      post "/api/v1/login", params: { session: { email: "nobody@example.com", password: "password123" } }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
