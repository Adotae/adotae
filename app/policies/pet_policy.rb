# frozen_string_literal: true

class PetPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if admin?
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
    @user.present?
  end

  def show?
    admin? || @pet.user == @user
  end

  def create?
    @user.present?
  end

  def update?
    admin? || @pet.user == @user
  end

  def destroy?
    admin? || @pet.user == @user
  end

  def around?
    @user.present?
  end

  def favorites?
    @user.present?
  end

  def adoption?
    @user.present?
  end
end
