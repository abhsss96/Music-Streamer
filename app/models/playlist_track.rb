class PlaylistTrack < ApplicationRecord
  belongs_to :playlist, inverse_of: :playlist_tracks
  belongs_to :track

  acts_as_list scope: :playlist_id, column: :position, top_of_list: 1
end
