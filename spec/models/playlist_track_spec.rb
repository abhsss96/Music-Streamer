require "rails_helper"

RSpec.describe PlaylistTrack, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:playlist) }
    it { is_expected.to belong_to(:track) }
  end

  describe "position management (acts_as_list)" do
    let(:playlist) { create(:playlist) }

    it "appends new tracks at the bottom of the list" do
      first = create(:playlist_track, playlist: playlist)
      second = create(:playlist_track, playlist: playlist)

      expect(first.reload.position).to eq(1)
      expect(second.reload.position).to eq(2)
    end

    it "shifts other tracks when moved to a new position" do
      first = create(:playlist_track, playlist: playlist)
      second = create(:playlist_track, playlist: playlist)
      third = create(:playlist_track, playlist: playlist)

      third.insert_at(1)

      expect(third.reload.position).to eq(1)
      expect(first.reload.position).to eq(2)
      expect(second.reload.position).to eq(3)
    end

    it "closes the gap when a track is removed" do
      first = create(:playlist_track, playlist: playlist)
      second = create(:playlist_track, playlist: playlist)

      first.destroy

      expect(second.reload.position).to eq(1)
    end
  end
end
