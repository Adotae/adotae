class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :role
      t.boolean :active
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
