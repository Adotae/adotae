# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    name { "Test Test Test" }
    email { "test@adotae.com.br" }
    password { "AdotaeTest@0101" }
    cpf { CPF.generate }
  end
end
