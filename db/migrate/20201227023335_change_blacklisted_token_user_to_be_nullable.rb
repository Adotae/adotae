class ChangeBlacklistedTokenUserToBeNullable < ActiveRecord::Migration[6.1]
  def change
    remove_reference :blacklisted_tokens, :user
    add_reference :blacklisted_tokens, :user, null: true, foreign_key: true
  end
end
