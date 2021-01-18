module ApiErrors::ResourceErrors
  class ResourceNotFoundError < ApiErrors::BaseError
    def status
      :not_found
    end

    def message
      I18n.t("adotae.errors.resource.not_found")
    end
  end
end
