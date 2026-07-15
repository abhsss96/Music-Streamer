class Artist < ApplicationRecord
  has_many :albums, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :followers, through: :follows, source: :user

  validates :name, presence: true

  scope :search, ->(query) {
    tsquery = sanitize_sql_array([ "plainto_tsquery('english', ?)", query ])
    where("search_vector @@ (#{tsquery})")
      .order(Arel.sql("ts_rank(search_vector, #{tsquery}) DESC"))
  }

  def as_json(options = {})
    super(options.merge(except: Array(options[:except]) + [ :search_vector ]))
  end
end
