module ApiErrors::UserErrors
  class UserNotDestroyedError < ApiErrors::BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.user.not_destroyed")
    end
  end
end