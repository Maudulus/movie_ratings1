class RemoveNotNullConstraintForMovieRatings < ActiveRecord::Migration
  def up
    change_column :movies, :rating, :integer, null: true
  end

  def down
    change_column :movies, :rating, :integer, null: false
  end
end
