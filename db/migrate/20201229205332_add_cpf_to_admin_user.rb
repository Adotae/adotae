class AddCpfToAdminUser < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :cpf, :string, unique: true
  end
end
