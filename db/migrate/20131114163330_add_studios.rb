class AddStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_column :movies, :studio_id, :integer
  end
end
