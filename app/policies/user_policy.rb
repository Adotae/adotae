class UserPolicy < ApplicationPolicy

  def index?
    user.instance_of?(AdminUser) && user.admin?
  end

  def show?
    user.instance_of?(AdminUser) && user.admin?
  end

  def create?
    user.instance_of?(AdminUser) && user.admin?
  end

  def update?
    user.instance_of?(AdminUser) && user.admin?
  end

  def destroy?
    user.instance_of?(AdminUser) && user.admin?
  end

end