require "rails_helper"

RSpec.describe JsonWebToken do
  describe ".encode / .decode" do
    it "round-trips a payload" do
      token = described_class.encode({ user_id: 42 })
      decoded = described_class.decode(token)

      expect(decoded[:user_id]).to eq(42)
    end

    it "embeds an expiry claim" do
      token = described_class.encode({ user_id: 1 }, expires_in: 1.hour)
      decoded = described_class.decode(token)

      expect(decoded[:exp]).to be_within(5).of(1.hour.from_now.to_i)
    end

    it "raises a DecodeError for an expired token" do
      token = described_class.encode({ user_id: 1 }, expires_in: -1.minute)

      expect { described_class.decode(token) }.to raise_error(JsonWebToken::DecodeError)
    end

    it "raises a DecodeError for a tampered token" do
      token = described_class.encode({ user_id: 1 })

      expect { described_class.decode("#{token}garbage") }.to raise_error(JsonWebToken::DecodeError)
    end
  end
end
