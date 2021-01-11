module ApiErrors::AdoptionErrors
  class CantCreateAdoption < ApiErrors::BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.adoption.cant_create")
    end
  end
end