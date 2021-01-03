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
      @user.instance_of?(User)
    end
  
    def admin?
      @user.instance_of?(AdminUser) && @user.admin?
    end
  
    def moderator?
      @user.instance_of?(AdminUser) && @user.moderator?
    end
  
    def manager?
      @user.instance_of?(AdminUser) && @user.manager?
    end
  end

  def initialize(user, record)
    raise Pundit::NotAuthorizedError unless user
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
    @user.instance_of?(User)
  end

  def admin?
    @user.instance_of?(AdminUser) && @user.admin?
  end

  def moderator?
    @user.instance_of?(AdminUser) && @user.moderator?
  end

  def manager?
    @user.instance_of?(AdminUser) && @user.manager?
  end
end
