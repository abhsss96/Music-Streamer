FactoryBot.define do
  factory :album do
    sequence(:title) { |n| "Album #{n}" }
    release_date { Date.new(2020, 1, 1) }
    artist
  end
end
