class AddAdminUserReferenceToRefreshTokens < ActiveRecord::Migration[6.1]
  def change
    add_reference :refresh_tokens, :admin_user, null: true, foreign_key: true
  end
end
