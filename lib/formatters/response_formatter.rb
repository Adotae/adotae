module Formatters
  module ResponseFormatter

    def render_success(data: nil, message: nil)
      response = { status: I18n.t('adotae.response.success') }
      response[:message] = message if message
      response[:data] = data if data

      render json: response, status: 200
    end

    def render_error(status, options = {})
      status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
      response = { status: I18n.t('adotae.response.error') }
      response[:error] = options[:object] ?
        options[:object].errors.full_messages[0] : options[:message]

      render json: response, status: status
    end

  end
end