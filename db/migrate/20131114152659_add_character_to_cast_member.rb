class AddCharacterToCastMember < ActiveRecord::Migration
  def change
    add_column :cast_members, :character, :string
  end
end
