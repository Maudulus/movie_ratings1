class CreateQueuedMovies < ActiveRecord::Migration
  def change
    create_table :queued_movies do |t|
      t.integer :movie_id, null: false
      t.timestamps
    end

    add_index :queued_movies, :movie_id, unique: true
  end
end
