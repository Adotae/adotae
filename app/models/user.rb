# frozen_string_literal: true

class User < ApplicationRecord
  api_guard_associations refresh_token: "refresh_tokens", blacklisted_token: "blacklisted_tokens"
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  has_secure_password

  # Validations
  validates :name,
            presence: true,
            length: { in: 10..255 }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :phone,
            uniqueness: { on: :create, allow_nil: true },
            format: { with: /\A\(\d{2}\)\s\d{5}-\d{4}\Z/, allow_nil: true }

  validates :password,
            presence: { on: :create },
            length: { in: 8..100, allow_nil: true },
            format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%\^&*]).{8,100}\Z/, allow_nil: true }

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
end
