require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe "associations" do
    it { is_expected.to have_many(:playlists).dependent(:destroy) }
    it { is_expected.to have_many(:follows).dependent(:destroy) }
    it { is_expected.to have_many(:followed_artists).through(:follows) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:liked_tracks).through(:likes) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value("person@example.com").for(:email) }
    it { is_expected.to_not allow_value("not-an-email").for(:email) }

    it "requires a password of at least 8 characters" do
      user = build(:user, password: "short")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end
  end

  describe "#as_json" do
    it "never includes the password digest" do
      user = create(:user)
      expect(user.as_json).not_to have_key("password_digest")
    end
  end

  it "normalizes email to a downcased, stripped value" do
    user = create(:user, email: "  Person@Example.com ")
    expect(user.email).to eq("person@example.com")
  end
end
