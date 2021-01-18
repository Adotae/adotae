require 'rails_helper'

RSpec.describe "Pets", type: :request do

  let(:user) { create(:user_with_pets) }
  let(:admin) { create(:admin) }
  let(:user_tokens) { jwt_and_refresh_token(user, "user") }
  let(:admin_tokens) { jwt_and_refresh_token(admin, "admin_user") }
  let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}
  let(:admin_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{admin_tokens[0]}" }}

  describe "GET pets#index" do
    before { get pets_path }

    it "is a success when authenticated" do
      get pets_path, headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns all user pets" do
      get pets_path, headers: user_headers
      
      body = JSON.parse(response.body)
      expect(body["data"].size).to eq(user.pets.size)
    end

    it "returns all pets for a specific user" do
      get pets_path, params: { user: user.id }, headers: admin_headers

      body = JSON.parse(response.body)
      expect(body["data"].size).to eq(user.pets.size)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when specified user doesn't exist" do
      get pets_path, params: { user: 999 }, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.not_found"))
    end
  end

  describe "GET pets#show" do
    before { get pet_path(id: user.pets.first.id) }

    it "is a success when authenticated" do
      get pet_path(id: user.pets.first.id), headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns specified pet if user owns it" do
      pet = user.pets.first

      get pet_path(id: pet.id), headers: user_headers
      
      body = JSON.parse(response.body)
      data = body["data"]
      validate_pet_response(data, pet)
    end

    it "returns specified pet if admin user" do
      pet = user.pets.first

      get pet_path(id: pet.id), headers: admin_headers
      
      body = JSON.parse(response.body)
      data = body["data"]
      validate_pet_response(data, pet)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message if user doesn't owns it" do
      pet = create(:pet)
      get pet_path(id: pet.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end

    it "returns error message when specified pet doesn't exist" do
      get pet_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.pet.not_found"))
    end
  end

  describe "POST pets#create" do
    let!(:params) {{
      name: "Test name",
      kind: "dog",
      breed: "shitzu",
      gender: "male",
      age: 5,
      height: 60,
      weight: 20000,
      neutered: true,
      dewormed: true,
      vaccinated: true,
      description: "The long description...",
      photos: {
        "0": Rack::Test::UploadedFile.new("spec/fixtures/photos/pet/01.jpg", "image/jpeg")
      }
    }}

    before { post pets_path, params: params }

    it "is a success when authenticated and valid params" do
      post pets_path, params: params, headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      post pets_path, params: params.except(:photos), headers: user_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns created pet" do
      post pets_path, params: params.merge({ user_id: user.id }), headers: admin_headers
      body = JSON.parse(response.body)
      data = body["data"]
      created_pet = Pet.find(data["id"])
      validate_pet_response(data, created_pet)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end
  end

  describe "PUT pets#update" do
    let!(:pet) { user.pets.last }
    let!(:params) {{
      name: "New test name",
      kind: "cat",
      breed: "shitzu",
      gender: "female",
      age: 10,
      height: 30,
      weight: 10000,
      neutered: true,
      dewormed: false,
      vaccinated: true,
      description: "The new long description...",
      photos: {
        "0": Rack::Test::UploadedFile.new("spec/fixtures/photos/pet/02.jpg", "image/jpeg")
      }
    }}

    before { put pet_path(id: pet.id), params: params }

    it "is a success when authenticated and valid params" do
      put pet_path(id: pet.id), params: params, headers: user_headers
      pet.reload
      params.merge!({
        id: pet.id,
        size: pet.size,
        can_be_adopted: pet.can_be_adopted,
        photos: pet.photos_urls
      })
      validate_pet_response(JSON.parse(params.to_json), pet)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      params[:name] = nil
      put pet_path(id: pet.id), params: params, headers: admin_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      pet = create(:pet)
      put pet_path(id: pet.id), params: params, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns updated pet" do
      put pet_path(id: pet.id), params: params, headers: user_headers
      pet.reload
      body = JSON.parse(response.body)
      data = body["data"]
      validate_pet_response(data, pet)
    end

    it "returns error message when not found" do
      put pet_path(id: 999), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.pet.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      pet = create(:pet)
      put pet_path(id: pet.id), params: params, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "DELETE pets#destroy" do
    let!(:pet) { create(:pet) }

    before { delete pet_path(id: pet.id) }

    it "is a success when authenticated" do
      pet = user.pets.first
      delete pet_path(id: pet.id), headers: user_headers
      expect { Pet.find(pet.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      delete pet_path(id: pet.id), headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns deleted pet" do
      delete pet_path(id: pet.id), headers: admin_headers
      body = JSON.parse(response.body)
      data = body["data"]
      validate_pet_response(data, pet.tap{ |p| p.photos = [] })
    end

    it "returns error message when error on destroying" do
      pet = user.pets.last
      allow(Pet).to receive(:find).with(pet.id.to_s).and_return(pet)
      allow(pet).to receive(:destroy).and_return(false)

      delete pet_path(id: pet.id), headers: user_headers
      
      body = JSON.parse(response.body)
      expect(Pet).to have_received(:find).at_least(:once)
      expect(pet).to have_received(:destroy)
      expect(body["error"]).to include(I18n.t("adotae.errors.pet.not_destroyed"))
    end

    it "returns error message when not found" do
      delete pet_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.pet.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      delete pet_path(id: pet.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "GET pets#around" do
  
  end

  describe "GET pets#favorites" do
    let!(:user) { create(:user_with_favorited_pets) }

    before { get favorites_pets_path }

    it "is a success when authenticated" do
      get favorites_pets_path, headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns user favorited pets" do
      get favorites_pets_path, headers: user_headers
      
      body = JSON.parse(response.body)
      expect(body["data"].size).to eq(user.favorited_pets.size)
    end

    it "returns favorited pets for a specific user" do
      get favorites_pets_path, params: { user: user.id }, headers: admin_headers

      body = JSON.parse(response.body)
      expect(body["data"].size).to eq(user.favorited_pets.size)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when specified user doesn't exist" do
      get favorites_pets_path, params: { user: 999 }, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.not_found"))
    end
  end

  def validate_pet_response(data, pet)
    expect(data["id"]).to               eq(pet.id)
    expect(data["name"]).to             eq(pet.name)
    expect(data["kind"]).to             eq(pet.kind)
    expect(data["breed"]).to            eq(pet.breed)
    expect(data["gender"]).to           eq(pet.gender)
    expect(data["age"]).to              eq(pet.age)
    expect(data["size"]).to             eq(pet.size)
    expect(data["height"]).to           eq(pet.height)
    expect(data["weight"]).to           eq(pet.weight)
    expect(data["neutered"]).to         eq(pet.neutered)
    expect(data["dewormed"]).to         eq(pet.dewormed)
    expect(data["vaccinated"]).to       eq(pet.vaccinated)
    expect(data["description"]).to      eq(pet.description)
    expect(data["can_be_adopted"]).to   eq(pet.can_be_adopted)
    expect(data["photos"].size).to      eq(pet.photos.size)
    expect(data["photos"]).to           match_array(pet.photos_urls)
  end
end
