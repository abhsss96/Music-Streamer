require "rails_helper"

RSpec.describe Track, type: :model do
  subject { build(:track) }

  describe "associations" do
    it { is_expected.to belong_to(:album) }
    it { is_expected.to belong_to(:artist) }
    it { is_expected.to have_many(:playlist_tracks).dependent(:destroy) }
    it { is_expected.to have_many(:playlists).through(:playlist_tracks) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:liked_by_users).through(:likes) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:duration_seconds) }
    it { is_expected.to validate_numericality_of(:duration_seconds).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:audio_object_key) }
    it { is_expected.to validate_uniqueness_of(:audio_object_key) }
    it { is_expected.to validate_presence_of(:license_type) }
  end
end
