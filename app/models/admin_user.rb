class AdminUser < ApplicationRecord
  api_guard_associations refresh_token: 'refresh_tokens', blacklisted_token: 'blacklisted_tokens'
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  has_secure_password

  # Relations
  has_many :roles

  # Scopes
  scope :active, -> { where(disabled: false) }

  def has_permission?(role_name)
    Role.where(admin_user_id: self.id, role: role_name, active: true).any?
  end

  def add_role(role_name)
    role = Role.where(admin_user_id: self.id, role: role_name).first
    role.update(active: true) if role && !role.active
    Role.create(admin_user_id: self.id, role: role_name) unless role
  end

  def remove_role(role_name)
    role = Role.where(admin_user_id: self.id, role: role_name).first
    role.update(active: false) if role && role.active
  end

  def admin?
    has_permission?('admin')
  end

  def as_json(options = {})
    super(options.merge({ except: [:password_digest] }))
  end
  
end
