class ChangeRefreshTokenUserToBeNullable < ActiveRecord::Migration[6.1]
  def change
    remove_reference :refresh_tokens, :user
    add_reference :refresh_tokens, :user, null: true, foreign_key: true
  end
end
