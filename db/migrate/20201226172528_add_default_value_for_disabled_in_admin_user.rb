class AddDefaultValueForDisabledInAdminUser < ActiveRecord::Migration[6.1]
  def change
    change_column :admin_users, :disabled, :boolean, default: false
  end
end
