class AddCanBeAdoptedToPet < ActiveRecord::Migration[6.1]
  def change
    add_column :pets, :can_be_adopted, :boolean, default: false
  end
end
