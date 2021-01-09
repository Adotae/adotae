module ApiErrors::UserErrors
  class UserOnDestroyError < ApiErrors::BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.user.on_destroy")
    end
  end
end