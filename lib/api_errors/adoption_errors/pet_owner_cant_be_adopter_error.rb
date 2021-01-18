module ApiErrors::AdoptionErrors
  class PetOwnerCantBeAdopterError < ApiErrors::BaseError
    def status = :bad_request
    def message = I18n.t("adotae.errors.adoption.owner_cant_be_adopter")
  end
end
