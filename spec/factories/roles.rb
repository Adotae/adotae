FactoryBot.define do
  factory :role do
    role { "MyString" }
    active { false }
    admin_user { nil }
  end
end
