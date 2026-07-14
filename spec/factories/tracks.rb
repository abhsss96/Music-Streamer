FactoryBot.define do
  factory :track do
    sequence(:title) { |n| "Track #{n}" }
    duration_seconds { 200 }
    sequence(:audio_object_key) { |n| "tracks/track-#{n}.mp3" }
    license_type { "cc-by" }
    attribution_text { "Licensed under CC BY 4.0" }
    source { "seed" }
    album
    artist { album.artist }
  end
end
