class CreateTracks < ActiveRecord::Migration[8.1]
  def change
    create_table :tracks do |t|
      t.string :title, null: false
      t.references :album, null: false, foreign_key: true
      t.references :artist, null: false, foreign_key: true
      t.integer :duration_seconds, null: false
      t.string :audio_object_key, null: false
      t.string :license_type, null: false
      t.text :attribution_text
      t.string :source

      t.timestamps
    end
    add_index :tracks, :title
    add_index :tracks, :audio_object_key, unique: true
  end
end
