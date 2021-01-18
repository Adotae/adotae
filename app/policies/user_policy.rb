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
    admin_role? || manager_role?
  end

  def update?
    admin_role?
  end

  def destroy?
    admin_role?
  end
end
