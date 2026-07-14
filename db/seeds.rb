# Sample catalog data for local development. Idempotent: safe to run repeatedly.
#
# Audio object keys point at objects that must exist in the configured bucket
# (see docker-compose.yml's minio-seed step) for the /play endpoint to return
# a working signed URL.

catalog = [
  {
    artist: { name: "Componibile Sunrise", bio: "Ambient electronic duo releasing under Creative Commons." },
    albums: [
      {
        title: "Waking Hours",
        release_date: "2021-03-14",
        tracks: [
          { title: "First Light", duration_seconds: 214 },
          { title: "Coffee Static", duration_seconds: 187 },
          { title: "Commute", duration_seconds: 251 }
        ]
      }
    ]
  },
  {
    artist: { name: "Marlowe & The Tin Cans", bio: "Lo-fi indie folk trio." },
    albums: [
      {
        title: "Rust Belt Postcards",
        release_date: "2019-09-01",
        tracks: [
          { title: "Gary, Indiana", duration_seconds: 198 },
          { title: "Freight Line", duration_seconds: 233 }
        ]
      },
      {
        title: "Porch Light Sessions",
        release_date: "2022-06-20",
        tracks: [
          { title: "June Bugs", duration_seconds: 176 },
          { title: "Screen Door", duration_seconds: 205 }
        ]
      }
    ]
  },
  {
    artist: { name: "DJ Kelvin Wave", bio: "Downtempo producer, Jamendo Creative Commons catalog." },
    albums: [
      {
        title: "Low Tide",
        release_date: "2020-11-05",
        tracks: [
          { title: "Undertow", duration_seconds: 302 },
          { title: "Sandbar", duration_seconds: 267 },
          { title: "Riptide", duration_seconds: 289 }
        ]
      }
    ]
  }
]

catalog.each do |entry|
  artist = Artist.find_or_create_by!(name: entry[:artist][:name]) do |a|
    a.bio = entry[:artist][:bio]
  end

  entry[:albums].each do |album_entry|
    album = Album.find_or_create_by!(title: album_entry[:title], artist: artist) do |al|
      al.release_date = album_entry[:release_date]
    end

    album_entry[:tracks].each do |track_entry|
      slug = track_entry[:title].parameterize
      Track.find_or_create_by!(title: track_entry[:title], album: album, artist: artist) do |t|
        t.duration_seconds = track_entry[:duration_seconds]
        t.audio_object_key = "seed/#{artist.name.parameterize}/#{slug}.mp3"
        t.license_type = "cc-by"
        t.attribution_text = "#{track_entry[:title]} by #{artist.name}, licensed under CC BY 4.0"
        t.source = "seed"
      end
    end
  end
end

demo_user = User.find_or_create_by!(email: "demo@example.com") do |u|
  u.password = "password123"
end

first_playlist_tracks = Track.order(:id).limit(3)
demo_playlist = Playlist.find_or_create_by!(name: "Demo Mix", user: demo_user)
first_playlist_tracks.each { |track| demo_playlist.tracks << track unless demo_playlist.tracks.include?(track) }

puts "Seeded #{Artist.count} artists, #{Album.count} albums, #{Track.count} tracks."
puts "Demo user: demo@example.com / password123"
