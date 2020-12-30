# frozen_string_literal: true

module Account
  class RegistrationController < ApiGuard::RegistrationController
    private

    def sign_up_params
      params.permit(
        :name,
        :email,
        :phone,
        :password,
        :password_confirmation,
        :cpf,
        :cnpj
      )
    end
  end
end
