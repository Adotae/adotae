module ApiErrors::PetErrors
  class PetCantBeAdoptedError < ApiErrors::BaseError
    def status = :bad_request
    def message = I18n.t("adotae.errors.pet.cant_be_adopted")
  end
end
