# frozen_string_literal: true

module Donation
  class AdoptionPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        if admin_user?
          scope.all
        else
          scope.where(giver: @user)
        end
      end
    end

    def initialize(user, donation)
      @user = user
      @donation = donation
    end

    def index?
      admin_user? || user?
    end

    def show?
      admin_user? || @donation.giver == @user
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
end
