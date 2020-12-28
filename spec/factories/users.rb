FactoryBot.define do
  factory :user do
    name { 'Test Test Test' }
    email { 'test@adotae.com.br' }
    phone { '(11) 99999-8888' }
    password { 'AdotaeTest@0101' }
  end
end