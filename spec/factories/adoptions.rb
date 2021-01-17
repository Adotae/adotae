FactoryBot.define do
  factory :adoption, aliases: [:donation] do
    giver factory: :user
    adopter factory: :user
    pet
    status { "incomplete" }

    after(:create) do |adoption, evaluator|
      if adoption.invalid?
        byebug
      end
    end

    factory :adoption_with_completed_at, aliases: [:donation_with_completed_at] do
      completed_at { Date.yesterday }
    end
  end
end
