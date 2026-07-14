require "rails_helper"

RSpec.describe Playlist, type: :model do
  subject { build(:playlist) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:playlist_tracks).dependent(:destroy) }
    it { is_expected.to have_many(:tracks).through(:playlist_tracks) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end
