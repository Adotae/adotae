class User < ApplicationRecord
  api_guard_associations refresh_token: 'refresh_tokens', blacklisted_token: 'blacklisted_tokens'
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  has_secure_password

  # Validations
  validates :name, presence: true, length: { in: 10..255 }

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A(\S+)@(.+)\.(\S+)\z/

  validates_uniqueness_of :phone, allow_nil: true, on: :create
  validates_format_of :phone, with: /\A\(\d{2}\)\s\d{5}-\d{4}\Z/, allow_nil: true

  validates_presence_of :password, on: :create
  validates_length_of :password, in: 8..100, allow_nil: true
  validates_format_of :password, with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*]).{8,100}\Z/, allow_nil: true

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
  
end