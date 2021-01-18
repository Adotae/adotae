FactoryBot.define do
  factory :donation, class: "Adoption" do
    giver factory: :user
    adopter { nil }
    pet { create(:pet, user: giver) }
    status { "incomplete" }

    after(:create) do |donation, evaluator|
      donation.pet.update!(can_be_adopted: true)
    end

    factory :donation_with_completed_at do
      adopter factory: :user
      completed_at { Date.yesterday }
    end
  end
end
