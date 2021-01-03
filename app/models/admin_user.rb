# frozen_string_literal: true

class AdminUser < ApplicationRecord
  api_guard_associations refresh_token: "refresh_tokens", blacklisted_token: "blacklisted_tokens"
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  # Validations
  validates :name, presence: true, length: { in: 10..255 }

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            presence: { on: :create },
            length: { in: 8..100, allow_nil: true },
            format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%\^&*]).{8,100}\Z/, allow_nil: true }

  validates :cpf, presence: true, uniqueness: true
  validate :cpf_is_valid?

  # Relations
  has_many :roles, dependent: :destroy

  # Scopes
  scope :active, -> { where(disabled: false) }
  scope :by_cpf, -> (cpf) { where(cpf: cpf) }

  has_secure_password

  def permission?(role_name)
    Role.where(admin_user_id: id, role: role_name, active: true).any?
  end

  def add_role(role_name)
    role = Role.find_by(admin_user_id: id, role: role_name)
    role.update(active: true) if role && !role.active
    Role.create(admin_user_id: id, role: role_name) unless role
  end

  def remove_role(role_name)
    role = Role.find_by(admin_user_id: id, role: role_name)
    role.update(active: false) if role&.active
  end

  def admin?
    permission?("admin")
  end

  def moderator?
    permission?("moderator")
  end

  def manager?
    permission?("manager")
  end

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end

  private

  def cpf_is_valid?
    return if cpf.blank?
    return if cpf.match(/\A\d+\Z/) && CPF.valid?(cpf)
    errors.add(:cpf, I18n.t("activerecord.errors.models.admin_user.attributes.cpf.invalid"))
  end
end
