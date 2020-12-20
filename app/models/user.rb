class User < ApplicationRecord
  api_guard_associations refresh_token: 'refresh_tokens', blacklisted_token: 'blacklisted_tokens'
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  has_secure_password

  # Validations
  validates :name, presence: true, length: { in: 10..255 }

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A(\S+)@(.+)\.(\S+)\z/

  validates :phone, uniqueness: true
  validates_format_of :phone, with: /\A\(\d{2}\)\s\d{5}-\d{4}\Z/

  validates :password, presence: true, length: { in: 8..100 }
  validates_format_of :password, with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,100}\Z/

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
  
end