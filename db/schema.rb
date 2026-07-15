# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_15_170251) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "albums", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.date "release_date"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
    t.index ["title"], name: "index_albums_on_title"
  end

  create_table "artists", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.virtual "search_vector", type: :tsvector, as: "to_tsvector('english'::regconfig, (COALESCE(name, ''::character varying))::text)", stored: true
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_artists_on_name"
    t.index ["search_vector"], name: "index_artists_on_search_vector", using: :gin
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["artist_id"], name: "index_follows_on_artist_id"
    t.index ["user_id", "artist_id"], name: "index_follows_on_user_id_and_artist_id", unique: true
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "track_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["track_id"], name: "index_likes_on_track_id"
    t.index ["user_id", "track_id"], name: "index_likes_on_user_id_and_track_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "playlist_tracks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "playlist_id", null: false
    t.integer "position", null: false
    t.bigint "track_id", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id", "position"], name: "index_playlist_tracks_on_playlist_id_and_position"
    t.index ["playlist_id"], name: "index_playlist_tracks_on_playlist_id"
    t.index ["track_id"], name: "index_playlist_tracks_on_track_id"
    t.unique_constraint ["playlist_id", "position"], deferrable: :deferred
  end

  create_table "playlists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "artist_id", null: false
    t.text "attribution_text"
    t.string "audio_object_key", null: false
    t.datetime "created_at", null: false
    t.integer "duration_seconds", null: false
    t.string "license_type", null: false
    t.string "source"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
    t.index ["audio_object_key"], name: "index_tracks_on_audio_object_key", unique: true
    t.index ["title"], name: "index_tracks_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "albums", "artists"
  add_foreign_key "follows", "artists"
  add_foreign_key "follows", "users"
  add_foreign_key "likes", "tracks"
  add_foreign_key "likes", "users"
  add_foreign_key "playlist_tracks", "playlists"
  add_foreign_key "playlist_tracks", "tracks"
  add_foreign_key "playlists", "users"
  add_foreign_key "tracks", "albums"
  add_foreign_key "tracks", "artists"
end
