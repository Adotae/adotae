FactoryBot.define do
  factory :role do
    role { "admin" }
    admin_user

    factory :role_admin do
      role { "admin" }
    end

    factory :role_with_invalid_role do
      role { "somerandomrole" }
    end

    factory :role_with_invalid_admin do
      role { "manager" }
      admin_user { nil }
    end
  end
end
