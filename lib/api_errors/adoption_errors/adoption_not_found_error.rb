module ApiErrors::AdoptionErrors
  class AdoptionNotFoundError < ApiErrors::BaseError
    def status = :not_found
    def message = I18n.t("adotae.errors.adoption.not_found")
  end
end
