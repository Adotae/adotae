module ApiErrors::AdminUserErrors
  class AdminUserOnDestroyError < ApiErrors::BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.admin_user.on_destroy")
    end
  end
end