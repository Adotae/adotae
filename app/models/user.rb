# frozen_string_literal: true

class User < ApplicationRecord
  api_guard_associations refresh_token: "refresh_tokens", blacklisted_token: "blacklisted_tokens"
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

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

  # Relations
  has_many :pets, dependent: :destroy

  has_many :fav_pets, class_name: "FavoritedPet"
  has_many :favorited_pets, through: :fav_pets, source: :pet

  has_many :donations, class_name: "Adoption", foreign_key: 'giver_id'
  has_many :adoptions, class_name: "Adoption", foreign_key: 'adopter_id'

  has_secure_password

  def adoptions_and_donations
    Adoption.where("giver_id = ? OR adopter_id = ?", id, id)
  end

  def juridical_person?
    cnpj.present?
  end

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end

  private

  def cpf_is_valid?
    return if cpf.blank?
    return if cpf.match(/\A\d+\Z/) && CPF.valid?(cpf)
    errors.add(:cpf, I18n.t("activerecord.errors.models.user.attributes.cpf.invalid"))
  end

  def cnpj_is_valid?
    return if cnpj.blank?
    return if cnpj.match(/\A\d+\Z/) && CNPJ.valid?(cnpj)
    errors.add(:cnpj, I18n.t("activerecord.errors.models.user.attributes.cnpj.invalid"))
  end
end
