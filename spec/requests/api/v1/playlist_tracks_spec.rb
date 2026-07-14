require "rails_helper"

RSpec.describe "Playlist tracks", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:playlist) { create(:playlist, user: user) }
  let(:track) { create(:track) }

  describe "POST /api/v1/playlists/:playlist_id/tracks" do
    it "adds a track to the playlist" do
      post "/api/v1/playlists/#{playlist.id}/tracks", params: { track_id: track.id }, headers: auth_headers(user)

      expect(response).to have_http_status(:created)
      expect(json_response["track"]["id"]).to eq(track.id)
      expect(playlist.tracks).to include(track)
    end

    it "appends subsequent tracks at the end by default" do
      first_track = create(:track)
      second_track = create(:track)

      post "/api/v1/playlists/#{playlist.id}/tracks", params: { track_id: first_track.id }, headers: auth_headers(user)
      post "/api/v1/playlists/#{playlist.id}/tracks", params: { track_id: second_track.id }, headers: auth_headers(user)

      expect(playlist.playlist_tracks.order(:position).map(&:track_id)).to eq([ first_track.id, second_track.id ])
    end

    it "inserts at a given position when provided" do
      first_track = create(:track)
      post "/api/v1/playlists/#{playlist.id}/tracks", params: { track_id: first_track.id }, headers: auth_headers(user)

      post "/api/v1/playlists/#{playlist.id}/tracks",
        params: { track_id: track.id, position: 1 },
        headers: auth_headers(user)

      expect(playlist.playlist_tracks.order(:position).map(&:track_id)).to eq([ track.id, first_track.id ])
    end

    it "forbids adding a track to another user's playlist" do
      other_playlist = create(:playlist, user: other_user)

      post "/api/v1/playlists/#{other_playlist.id}/tracks", params: { track_id: track.id }, headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /api/v1/playlists/:playlist_id/tracks/:id" do
    it "reorders a track within the playlist" do
      first = create(:playlist_track, playlist: playlist)
      second = create(:playlist_track, playlist: playlist)

      patch "/api/v1/playlists/#{playlist.id}/tracks/#{second.id}",
        params: { position: 1 },
        headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(second.reload.position).to eq(1)
      expect(first.reload.position).to eq(2)
    end

    it "forbids reordering tracks in another user's playlist" do
      other_playlist = create(:playlist, user: other_user)
      playlist_track = create(:playlist_track, playlist: other_playlist)

      patch "/api/v1/playlists/#{other_playlist.id}/tracks/#{playlist_track.id}",
        params: { position: 1 },
        headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /api/v1/playlists/:playlist_id/tracks/:id" do
    it "removes a track from the playlist" do
      playlist_track = create(:playlist_track, playlist: playlist)

      delete "/api/v1/playlists/#{playlist.id}/tracks/#{playlist_track.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:no_content)
      expect(PlaylistTrack.exists?(playlist_track.id)).to be false
    end

    it "forbids removing a track from another user's playlist" do
      other_playlist = create(:playlist, user: other_user)
      playlist_track = create(:playlist_track, playlist: other_playlist)

      delete "/api/v1/playlists/#{other_playlist.id}/tracks/#{playlist_track.id}", headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
      expect(PlaylistTrack.exists?(playlist_track.id)).to be true
    end
  end
end
