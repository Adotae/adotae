# frozen_string_literals: true

module ApiErrors
  class BaseError < StandardError
    include ActiveModel::Serialization

    def initialize
      @status = status
      @message = message
    end

    def status = :bad_request
    def message = I18n.t("adotae.errors.base.base_error")
  end
end
