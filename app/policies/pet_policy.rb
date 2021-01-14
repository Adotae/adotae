# frozen_string_literal: true

class PetPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if admin_user?
        scope.all
      else
        scope.where(user: @user)
      end
    end
  end

  def initialize(user, pet)
    @user = user
    @pet = pet
  end

  def index?
    admin_user? || user?
  end

  def show?
    admin_user? || @pet.user == @user
  end

  def create?
    admin_role? || user?
  end

  def update?
    admin_role? || @pet.user == @user
  end

  def destroy?
    admin_role? || @pet.user == @user
  end

  def around?
    admin_role? || manager_role? || user?
  end

  def favorites?
    admin_role? || manager_role? || user?
  end
end
