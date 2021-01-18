# frozen_string_literals: true

module ErrorsHelper
  extend ActiveSupport::Concern

  include Pundit
  include ApiErrors

  included do
    # Error handling
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordNotDestroyed, with: :record_not_destroyed
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  end

  private

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

  def record_not_destroyed(error)
    case error.record
    when User
      handle_error(UserErrors::UserNotDestroyedError.new)
    when AdminUser
      handle_error(AdminUserErrors::AdminUserNotDestroyedError.new)
    when Pet
      handle_error(PetErrors::PetNotDestroyedError.new)
    when Adoption
      handle_error(AdoptionErrors::AdoptionNotDestroyedError.new)
    else
      handle_error(ResourceErrors::ResourceNotDestroyedError.new)
    end
  end

  def record_invalid(error)
    render_error(:unprocessable_entity, object: error.record)
  end
end
