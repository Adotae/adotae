module ApiErrors::PetErrors
  class PetNotDestroyedError < ApiErrors::BaseError
    def status = :bad_request
    def message = I18n.t("adotae.errors.pet.not_destroyed")
  end
end
