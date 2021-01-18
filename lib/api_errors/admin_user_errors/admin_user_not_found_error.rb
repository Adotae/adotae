module ApiErrors::AdminUserErrors
  class AdminUserNotFoundError < ApiErrors::BaseError
    def status = :not_found
    def message = I18n.t("adotae.errors.admin_user.not_found")
  end
end
