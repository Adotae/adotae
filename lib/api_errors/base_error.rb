# frozen_string_literals: true

module ApiErrors
  class BaseError < StandardError
    include ActiveModel::Serialization

    def initialize
      @status = status
      @message = message
    end

    # TODO: def status = :bad_request in ruby 3.0
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.base.base_error")
    end
  end
end
