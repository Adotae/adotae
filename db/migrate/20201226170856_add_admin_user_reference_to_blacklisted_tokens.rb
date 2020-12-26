class AddAdminUserReferenceToBlacklistedTokens < ActiveRecord::Migration[6.1]
  def change
    add_reference :blacklisted_tokens, :admin_user, null: true, foreign_key: true
  end
end
