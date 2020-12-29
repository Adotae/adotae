# frozen_string_literal: true

class Role < ApplicationRecord
  # Validations
  validates :role, presence: true
  validate :role_is_defined?
  validate :role_already_exits?, on: :create

  # Relations
  belongs_to :admin_user

  ROLES = %w[admin moderator manager].freeze

  private

  def role_is_defined?
    return unless ROLES.exclude?(role)
    errors.add(:role, I18n.t("activerecord.errors.models.role.attributes.role.invalid"))
  end

  def role_already_exits?
    return unless admin_user&.permission?(role)
    errors.add(:role, I18n.t("activerecord.errors.models.role.attributes.role.taken"))
  end
end
