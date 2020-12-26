class AdminUser < ApplicationRecord
  api_guard_associations refresh_token: 'refresh_tokens', blacklisted_token: 'blacklisted_tokens'
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  has_secure_password

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
  
end
