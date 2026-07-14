class User < ApplicationRecord
  has_secure_password

  has_many :playlists, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :followed_artists, through: :follows, source: :artist
  has_many :likes, dependent: :destroy
  has_many :liked_tracks, through: :likes, source: :track

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true

  def as_json(options = {})
    super(options.merge(except: Array(options[:except]) + [ :password_digest ]))
  end
end
