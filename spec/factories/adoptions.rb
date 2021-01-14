FactoryBot.define do
  factory :adoption, aliases: [:donation] do
    giver factory: :user
    adopter factory: :user
    pet
    status { "incomplete" }
  end
end
