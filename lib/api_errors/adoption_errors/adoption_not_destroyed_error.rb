module ApiErrors::AdoptionErrors
  class AdoptionNotDestroyedError < ApiErrors::BaseError
    def status = :bad_request
    def message = I18n.t("adotae.errors.adoption.not_destroyed")
  end
end
