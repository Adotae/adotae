module ApiErrors::PetErrors
  class PetOnDestroyError < ApiErrors::BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.pet.on_destroy")
    end
  end
end