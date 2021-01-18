class AddUniqueIndexToAdminUserCpf < ActiveRecord::Migration[6.1]
  def change
    add_index :admin_users, :cpf, unique: true
  end
end
