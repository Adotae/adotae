# frozen_string_literal: true

class AdminUserPolicy < ApplicationPolicy
  def me?
    admin? || moderator? || manager?
  end

  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end
end
