class AddSearchVectorToArtists < ActiveRecord::Migration[8.1]
  def change
    add_column :artists, :search_vector, :tsvector,
      as: "to_tsvector('english', coalesce(name, ''))", stored: true
    add_index :artists, :search_vector, using: :gin
  end
end
