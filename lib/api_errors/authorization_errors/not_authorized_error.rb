module ApiErrors::AuthorizationErrors
  class NotAuthorizedError < ApiErrors::BaseError
    def status = :forbidden
    def message = I18n.t("adotae.errors.authorization.unauthorized")
  end
end
