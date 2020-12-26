class CreateAdminUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_users do |t|
      t.string  :name
      t.string  :email
      t.string  :password_digest
      t.boolean :disabled

      t.timestamps
    end
  end
end
