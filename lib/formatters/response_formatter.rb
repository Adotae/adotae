# frozen_string_literal: true

module Formatters
  module ResponseFormatter
    def render_success(data: nil, message: nil)
      response = { status: I18n.t("adotae.response.success") }
      response[:message] = message if message

      if data
        model_class = get_model_class(data)
        blueprint = get_blueprint(model_class) if model_class
        response[:data] = blueprint ? blueprint.render_as_hash(data) : data
      end

      render json: response, status: :ok
    end

    def render_error(status, options = {})
      status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
      response = { status: I18n.t("adotae.response.error") }

      response[:error] = if options[:object]
        options[:object].errors.full_messages[0]
      else
        options[:message]
      end

      render json: response, status: status
    end

    private

    def a_model?(data)
      data.is_a?(ApplicationRecord)
    end

    def a_enumerable?(data)
      data.is_a?(Array) || data.is_a?(Enumerable)
    end

    def get_model_class(data)
      if a_enumerable?(data) && data.present? && a_model?(data[0])
        data[0].class
      elsif a_model?(data)
        data.class
      end
    end

    def get_blueprint(model_class)
      "#{model_class.name}Blueprint".constantize
    rescue NameError
      nil
    end
  end
end
