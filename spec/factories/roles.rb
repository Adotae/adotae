FactoryBot.define do
  factory :role do
    role { "admin" }
    admin_user { AdminUser.first.id }
  end

  factory :role_with_invalid_role do
    role { "somerandomrole" }
    admin_user { AdminUser.first.id }
  end

  factory :role_with_invalid_admin_id do
    role { "admin" }
    admin_user { 9999 }
  end
end
