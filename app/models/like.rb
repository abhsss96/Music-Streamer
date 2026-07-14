class Like < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :user_id, uniqueness: { scope: :track_id }
end
