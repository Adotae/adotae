module ApiErrors::PetErrors
  class PetCantBeAdoptedError < BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.pet.cant_be_adopted")
    end
  end
end