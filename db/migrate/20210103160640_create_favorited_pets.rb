class CreateFavoritedPets < ActiveRecord::Migration[6.1]
  def change
    create_table :favorited_pets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
