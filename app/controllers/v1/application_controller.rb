# frozen_string_literal: true

module V1
  class ApplicationController < ActionController::API
    include Pundit
    include ApiErrors

    before_action :authenticate_and_set_user_or_admin_user

    # Error handling
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ApiErrors::BaseError, with: :handle_error

    private

    def pundit_user
      @current_user || @current_admin_user
    end

    def user_not_authorized
      handle_error(AuthorizationErrors::NotAuthorizedError.new)
    end

    def record_not_found(error)
      case error.model
      when User.name
        handle_error(UserErrors::UserNotFoundError.new)
      when AdminUser.name
        handle_error(AdminUserErrors::AdminUserNotFoundError.new)
      when Pet.name
        handle_error(PetErrors::PetNotFoundError.new)
      when Adoption.name
        handle_error(AdoptionErrors::AdoptionNotFoundError.new)
      else
        handle_error(ResourceErrors::ResourceNotFoundError.new)
      end
    end

    def handle_error(error)
      render_error(error.status, message: error.message)
    end
  end
end
