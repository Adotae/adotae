class CreateAssociates < ActiveRecord::Migration[6.1]
  def change
    create_table :associates do |t|
      t.string :name
      t.string :cnpj, unique: true
      
      t.timestamps
    end
  end
end
