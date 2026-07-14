require "rails_helper"

RSpec.describe AudioUrlSigner, :stub_s3_env do
  describe ".call" do
    it "returns a GET URL scoped to the object key and bucket" do
      url = described_class.call("artists/1/tracks/1.mp3")

      expect(url).to start_with("http://localhost:9000/audio/artists/1/tracks/1.mp3")
    end

    it "signs the URL with a 5 minute default expiry" do
      url = described_class.call("artists/1/tracks/1.mp3")

      expect(url).to include("X-Amz-Expires=300")
    end

    it "honors a custom expiry" do
      url = described_class.call("artists/1/tracks/1.mp3", expires_in: 30.seconds)

      expect(url).to include("X-Amz-Expires=30")
    end
  end
end
