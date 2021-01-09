# frozen_string_literal: true

class AdminUserPolicy < ApplicationPolicy
  def me?
    admin_user?
  end

  def index?
    admin_role?
  end

  def show?
    admin_role?
  end

  def create?
    admin_role?
  end

  def update?
    admin_role?
  end

  def destroy?
    admin_role?
  end
end
