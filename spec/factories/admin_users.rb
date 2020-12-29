# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    name { Faker::Name.name_with_middle }
    email { Faker::Internet.unique.email }
    password { "AdotaeTest@0101" }
    
    factory :manager do
      after(:create) do |manager, evaluator|
        manager.add_role("manager")
      end
    end

    factory :moderator do
      after(:create) do |moderator, evaluator|
        moderator.add_role("moderator")
      end
    end

    factory :admin do
      after(:create) do |admin, evaluator|
        admin.add_role("admin")
      end
    end
  end
end
