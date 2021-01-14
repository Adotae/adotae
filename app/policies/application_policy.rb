# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  class Scope
    attr_reader :user, :scope
    
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    protected

    def user?
      @user.is_a?(User)
    end
  
    def admin_user?
      @user.is_a?(AdminUser)
    end

    def admin_role?
      admin_user? && @user.admin?
    end
  
    def moderator_role?
      admin_user? && @user.moderator?
    end
  
    def manager_role?
      admin_user? && @user.manager?
    end
  end

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  protected

  def user?
    @user.is_a?(User)
  end

  def admin_user?
    @user.is_a?(AdminUser)
  end

  def admin_role?
    admin_user? && @user.admin?
  end

  def moderator_role?
    admin_user? && @user.moderator?
  end

  def manager_role?
    admin_user? && @user.manager?
  end
end
