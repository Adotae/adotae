module ApiErrors::PetErrors
  class PetCantBeDonatedError < ApiErrors::BaseError
    def status = :bad_request
    def message = I18n.t("adotae.errors.pet.cant_be_donated")
  end
end
