module ApiErrors::ResourceErrors
  class ResourceNotDestroyedError < ApiErrors::BaseError
    def status = :bad_request
    def message = I18n.t("adotae.errors.resource.not_destroyed")
  end
end
