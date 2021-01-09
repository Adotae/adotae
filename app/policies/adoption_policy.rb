# frozen_string_literal: true

class AdoptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if admin_user?
        scope.all
      else
        scope.where(adopter: @user)
      end
    end
  end

  def initialize(user, adoption)
    @user = user
    @adoption = adoption
  end

  def index?
    admin_user? || user?
  end

  def show?
    admin_user? || @adoption.adopter == @user
  end

  def create?
    admin_role? || user?
  end

  def update?
    admin_role?
  end

  def destroy?
    admin_role?
  end
end
