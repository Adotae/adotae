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

    factory :user_with_pets do
      transient do
        pets_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:pet, evaluator.pets_count, user: user)
        user.reload
      end
    end

    factory :user_with_favorited_pets do
      transient do
        pets_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:favorited_pet, evaluator.pets_count, user: user)
        user.reload
      end
    end
  end
end
