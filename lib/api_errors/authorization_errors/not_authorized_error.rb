module ApiErrors::AuthorizationErrors
  class NotAuthorizedError < BaseError
    def status
      :forbidden
    end

    def message
      I18n.t("adotae.errors.authorization.unauthorized")
    end
  end
end