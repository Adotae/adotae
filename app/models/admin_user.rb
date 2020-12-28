class AdminUser < ApplicationRecord
  api_guard_associations refresh_token: 'refresh_tokens', blacklisted_token: 'blacklisted_tokens'
  has_many :refresh_tokens, dependent: :delete_all
  has_many :blacklisted_tokens, dependent: :delete_all

  # Validations
  validates :name, presence: true, length: { in: 10..255 }

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  validates_presence_of :password, on: :create
  validates_length_of :password, in: 8..100, allow_nil: true
  validates_format_of :password, with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*]).{8,100}\Z/, allow_nil: true

  # Relations
  has_many :roles

  has_secure_password

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
