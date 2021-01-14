FactoryBot.define do
  factory :pet do
    name { Faker::FunnyName.two_word_name }
    kind { "dog" }
    breed { "shitzu" }
    gender { "male" }
    age { Faker::Number.between(from: 1, to: 100) }
    height { Faker::Number.between(from: 1, to: 500) }
    weight { Faker::Number.between(from: 1, to: 500000) }
    neutered { Faker::Boolean.boolean }
    dewormed { Faker::Boolean.boolean }
    vaccinated { Faker::Boolean.boolean }
    description { Faker::Lorem.paragraph }
    user

    photos { [
      Rack::Test::UploadedFile.new("spec/fixtures/photos/pet/01.jpg", "image/jpeg"),
      Rack::Test::UploadedFile.new("spec/fixtures/photos/pet/02.jpg", "image/jpeg"),
      Rack::Test::UploadedFile.new("spec/fixtures/photos/pet/03.jpg", "image/jpeg")
    ] }

    factory :dog do
      kind { "dog" }
      breed { "shitzu" }
    end

    factory :cat do
      kind { "cat" }
      breed { "shitzu" }
    end
  end
end
