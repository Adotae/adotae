module ApiErrors::PetErrors
  class PetNotFoundError < ApiErrors::BaseError
    def status
      :not_found
    end

    def message
      I18n.t("adotae.errors.pet.not_found")
    end
  end
end
