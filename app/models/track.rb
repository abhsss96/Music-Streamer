class Track < ApplicationRecord
  belongs_to :album
  belongs_to :artist
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
  has_many :likes, dependent: :destroy
  has_many :liked_by_users, through: :likes, source: :user

  validates :title, presence: true
  validates :duration_seconds, presence: true, numericality: { greater_than: 0 }
  validates :audio_object_key, presence: true, uniqueness: true
  validates :license_type, presence: true
end
