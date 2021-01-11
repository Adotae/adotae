module ApiErrors::AdoptionErrors
  class AdoptionOnDestroyError < ApiErrors::BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.adoption.on_destroy")
    end
  end
end