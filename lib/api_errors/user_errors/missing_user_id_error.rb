module ApiErrors::UserErrors
  class MissingUserIdError < ApiErrors::BaseError
    def status = :unprocessable_entity
    def message = I18n.t("adotae.errors.user.missing_id")
  end
end
