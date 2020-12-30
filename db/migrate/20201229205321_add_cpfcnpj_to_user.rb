class AddCpfcnpjToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :cpf, :string, unique: true
    add_column :users, :cnpj, :string
  end
end
