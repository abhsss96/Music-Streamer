FactoryBot.define do
  factory :artist do
    sequence(:name) { |n| "Artist #{n}" }
    bio { "An independent artist." }
  end
end
