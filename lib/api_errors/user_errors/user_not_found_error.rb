module ApiErrors::UserErrors
  class UserNotFoundError < ApiErrors::BaseError
    def status
      :not_found
    end

    def message
      I18n.t("adotae.errors.user.not_found")
    end
  end
end