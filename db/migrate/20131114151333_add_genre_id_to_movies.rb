class AddGenreIdToMovies < ActiveRecord::Migration
  def up
    add_column :movies, :genre_id, :integer, null: false
    drop_table :movie_genres
  end

  def down
    create_table :movie_genres do |t|
      t.integer :movie_id, null: false
      t.integer :genre_id, null: false

      t.timestamps
    end

    remove_column :movies, :genre_id
  end
end
