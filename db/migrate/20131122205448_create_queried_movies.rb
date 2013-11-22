class CreateQueriedMovies < ActiveRecord::Migration
  def change
    create_table :queried_movies do |t|
      t.integer :movie_id
      t.timestamps
    end

    add_index :queried_movies, :movie_id, unique: true
  end
end
