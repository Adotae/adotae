module ApiErrors::AdminUserErrors
  class AdminUserNotDestroyedError < ApiErrors::BaseError
    def status = :bad_request
    def message = I18n.t("adotae.errors.admin_user.not_destroyed")
  end
end
