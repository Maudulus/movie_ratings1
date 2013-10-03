class CreateCastMembers < ActiveRecord::Migration
  def change
    create_table :cast_members do |t|
      t.integer :movie_id, null: false
      t.integer :actor_id, null: false

      t.timestamps
    end
  end
end
