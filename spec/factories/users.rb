# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "Test Test Test" }
    email { "test@adotae.com.br" }
    phone { "(11) 99999-8888" }
    password { "AdotaeTest@0101" }
    cpf { CPF.generate }

    factory :user_with_cnpj do
      cpf { nil }
      cnpj { CNPJ.generate }
    end
  end
end
