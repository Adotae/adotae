# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def me?
    user?
  end

  def index?
    admin_user?
  end

  def show?
    admin_user?
  end

  def create?
    manager_role?
  end

  def update?
    manager_role?
  end

  def destroy?
    manager_role?
  end
end
