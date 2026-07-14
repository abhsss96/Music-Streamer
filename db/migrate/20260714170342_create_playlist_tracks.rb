class CreatePlaylistTracks < ActiveRecord::Migration[8.1]
  def up
    create_table :playlist_tracks do |t|
      t.references :playlist, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.integer :position, null: false

      t.timestamps
    end
    add_index :playlist_tracks, [ :playlist_id, :position ]

    # A deferred unique constraint (rather than a plain unique index) so
    # acts_as_list can shift multiple rows' positions within one transaction
    # (e.g. moving a track to an earlier slot) without tripping the
    # uniqueness check on each individual UPDATE -- it's only checked at
    # commit, once every row has its final position.
    add_unique_constraint :playlist_tracks, [ :playlist_id, :position ], deferrable: :deferred
  end

  def down
    drop_table :playlist_tracks
  end
end
