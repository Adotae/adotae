class Role < ApplicationRecord
  
  # Validations
  validates_presence_of :role
  validate :role_is_defined?
  validate :role_already_exits?, on: :create
  
  # Relations
  belongs_to :admin_user
  
  ROLES = ['admin', 'moderator', 'manager']

  private

  def role_is_defined?
    if ROLES.exclude?(self.role)
      errors.add(:role, I18n.t("activerecord.errors.models.role.attributes.role.invalid"))
    end
  end

  def role_already_exits?
    if self.admin_user && self.admin_user.has_permission?(self.role)
      errors.add(:role, I18n.t("activerecord.errors.models.role.attributes.role.taken"))
    end
  end
  
end
