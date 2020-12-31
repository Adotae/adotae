class CreatePets < ActiveRecord::Migration[6.1]
  def change
    create_table :pets do |t|
      t.string      :name, null: false
      t.string      :kind, null: false
      t.string      :breed, null: false
      t.string      :gender, null: false
      t.integer     :age, null: false
      t.integer     :height, null: false
      t.integer     :weight, null: false
      t.boolean     :neutered, null: false
      t.boolean     :dewormed, null: false
      t.boolean     :vaccinated, null: false
      t.text        :description
      t.references  :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
