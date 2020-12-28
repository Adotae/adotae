class AddUniqueIndexToAdminUserEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :admin_users, :email, unique: true
  end
end
