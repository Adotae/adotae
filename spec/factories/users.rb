# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name_with_middle }
    email { Faker::Internet.unique.email }
    phone { Faker::PhoneNumber.unique.cell_phone }
    password { "AdotaeTest@0101" }
    cpf { CPF.generate }

    factory :user_with_cnpj do
      cpf { nil }
      cnpj { CNPJ.generate }
    end
  end
end
