class CreateBlacklistedTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :blacklisted_tokens do |t|
      t.string :token
      t.references :user, null: false, foreign_key: true
      t.datetime :expire_at

      t.timestamps
    end
  end
end
