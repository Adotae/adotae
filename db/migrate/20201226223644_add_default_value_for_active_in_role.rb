class AddDefaultValueForActiveInRole < ActiveRecord::Migration[6.1]
  def change
    change_column :roles, :active, :boolean, default: true
  end
end
