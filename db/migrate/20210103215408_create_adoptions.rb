class CreateAdoptions < ActiveRecord::Migration[6.1]
  def change
    create_table :adoptions do |t|
      t.references :giver, null: false, foreign_key: { to_table: :users }
      t.references :adopter, null: true, foreign_key: { to_table: :users } , default: nil
      t.references :associate, null: true, foreign_key: true, default: nil
      t.references :pet, null: false, foreign_key: true
      t.string     :status
      t.timestamp  :completed_at

      t.timestamps
    end
  end
end
