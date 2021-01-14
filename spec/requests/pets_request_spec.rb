require 'rails_helper'

RSpec.describe "Pets", type: :request do

  let!(:user) { create(:user) }
  let!(:manager) { create(:manager) }
  let!(:moderator) { create(:moderator) }
  let!(:admin) { create(:admin) }
  let!(:user_tokens) { jwt_and_refresh_token(user, "user") }
  let!(:manager_tokens) { jwt_and_refresh_token(manager, "admin_user") }
  let!(:moderator_tokens) { jwt_and_refresh_token(moderator, "admin_user") }
  let!(:admin_tokens) { jwt_and_refresh_token(admin, "admin_user") }
  let!(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}
  let!(:manager_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{manager_tokens[0]}" }}
  let!(:moderator_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{moderator_tokens[0]}" }}
  let!(:admin_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{admin_tokens[0]}" }}

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
      pet = build(:pet).tap{ |pet|
        pet.user = user
        pet.save
      }
      get pets_path, headers: user_headers
      expect(response.body).to include(pet.to_json)
    end

    it "returns all specified user pets" do
      pet = build(:pet).tap{ |pet|
        pet.user = user
        pet.save
      }
      get pets_path, params: { user_id: user.id }, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["data"]).to eq(pet) # TODO: Verifies equality
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when specified user doesn't exist" do
      get pets_path, params: { user_id: 999 }, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.not_found"))
    end
  end

end
