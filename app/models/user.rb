# frozen_string_literal: true

class User < ApplicationRecord
  api_guard_associations refresh_token: "refresh_tokens", blacklisted_token: "blacklisted_tokens"
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  has_secure_password

  # Validations
  validates :name, presence: true, length: { in: 10..255 }

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

  validates :cpf,
            presence: { unless: :cnpj? },
            uniqueness: { allow_nil: true }
  validate :cpf_is_valid?

  validates :cnpj, presence: { unless: :cpf? }
  validate :cnpj_is_valid?
 
  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end

  private

  def cpf_is_valid?
    return unless cpf.present?

    if cpf.match(/\A\d+\Z/)
      return if CPF.valid?(cpf)
      errors.add(:cpf, I18n.t("activerecord.errors.models.user.attributes.cpf.invalid"))
    else
      errors.add(:cpf, I18n.t("activerecord.errors.models.user.attributes.cpf.invalid"))
    end
  end

  def cnpj_is_valid?
    return unless cnpj.present?
    
    if cnpj.match(/\A\d+\Z/)
      return if CNPJ.valid?(cnpj)
      errors.add(:cnpj, I18n.t("activerecord.errors.models.user.attributes.cnpj.invalid"))
    else
      errors.add(:cnpj, I18n.t("activerecord.errors.models.user.attributes.cnpj.invalid"))
    end
  end
end
