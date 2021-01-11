# frozen_string_literal: true

class User < ApplicationRecord
  include AccountValidatable
  
  api_guard_associations refresh_token: "refresh_tokens",
                         blacklisted_token: "blacklisted_tokens"

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

  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  has_secure_password

  def juridical_person?
    cnpj.present?
  end

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
end
