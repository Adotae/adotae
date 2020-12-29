class AddUniqueIndexToUserPhone < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :phone, unique: true
  end
end
