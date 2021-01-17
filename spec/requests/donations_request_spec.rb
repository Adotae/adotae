require 'rails_helper'

RSpec.describe "Donations", type: :request do
  
  let(:user) { create(:user_with_donations) }
  let(:admin) { create(:admin) }
  let(:user_tokens) { jwt_and_refresh_token(user, "user") }
  let(:admin_tokens) { jwt_and_refresh_token(admin, "admin_user") }
  let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}
  let(:admin_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{admin_tokens[0]}" }}

  describe "GET donations#index" do
    before { get donations_path }

    it "is a success when authenticated" do
      get donations_path, headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns all user donations" do
      get donations_path, headers: user_headers
      
      body = JSON.parse(response.body)
      expect(body["data"].size).to eq(user.donations.size)
    end

    it "returns all donations for a specific user" do
      get donations_path, params: { user: user.id }, headers: admin_headers

      body = JSON.parse(response.body)
      expect(body["data"].size).to eq(user.donations.size)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when specified user doesn't exist" do
      get donations_path, params: { user: 999 }, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.not_found"))
    end
  end

  describe "GET donations#show" do
    before { get donation_path(id: user.donations.first.id) }

    it "is a success when authenticated" do
      get donation_path(id: user.donations.first.id), headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns specified donations if user owns it" do
      donation = user.donations.first

      get donation_path(id: donation.id), headers: user_headers
      
      body = JSON.parse(response.body)
      data = body["data"]
      validate_donation_response(data, donation)
    end

    it "returns specified donation if admin user" do
      donation = user.donations.first

      get donation_path(id: donation.id), headers: admin_headers
      
      body = JSON.parse(response.body)
      data = body["data"]
      validate_donation_response(data, donation)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message if user doesn't owns it" do
      donation = create(:donation)
      get donation_path(id: donation.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end

    it "returns error message when specified donation doesn't exist" do
      get donation_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.donation.not_found"))
    end
  end

  describe "POST donations#create" do
    let(:user) { create(:user_with_pets) }
    let(:user_tokens) { jwt_and_refresh_token(user, "user") }
    let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}
    
    let!(:pet) { user.pets.last }
    let!(:params) {{
      pet_id: pet.id
    }}

    before { post donations_path, params: params }

    # TODO: Should not permit when pet is already in adoption

    it "is a success when authenticated and valid params" do
      post donations_path, params: params, headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      post donations_path, params: {}, headers: user_headers
      expect(response).to have_http_status(:not_found)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns created donation" do
      post donations_path, params: params.merge!({ user_id: user.id }), headers: admin_headers
      body = JSON.parse(response.body)
      data = body["data"]
      created_donation = Adoption.find(data["id"])
      validate_donation_response(data, created_donation)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end
  end

  describe "PUT donations#update" do
    let!(:donation) { user.donations.last }
    let!(:params) {{
      status: "complete",
      completed_at: "2020-01-14T10:44:32.431Z"
    }}

    before { put donation_path(id: donation.id), params: params }

    it "is a success when authenticated and valid params" do
      put donation_path(id: donation.id), params: params, headers: admin_headers
      donation.reload
      params.merge!({
        id: donation.id,
        giver_id: donation.giver_id,
        adopter_id: donation.adopter_id,
        associate_id: donation.associate_id,
        pet_id: donation.pet_id,
        created_at: donation.created_at,
        updated_at: donation.updated_at
      })
      validate_donation_response(JSON.parse(params.to_json), donation)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      params = { status: "unknown_status" }
      put donation_path(id: donation.id), params: params, headers: admin_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      put donation_path(id: donation.id), params: params, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns updated donation" do
      put donation_path(id: donation.id), params: params, headers: admin_headers
      donation.reload
      body = JSON.parse(response.body)
      data = body["data"]
      validate_donation_response(data, donation)
    end

    it "returns error message when not found" do
      put donation_path(id: 999), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.donation.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      put donation_path(id: donation.id), params: params, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "DELETE donations#destroy" do
    let!(:donation) { create(:donation) }

    before { delete donation_path(id: user.donations.last.id) }

    it "is a success when authenticated and authorized" do
      donation = user.donations.first
      delete donation_path(id: donation.id), headers: admin_headers
      expect { Adoption.find(donation.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      donation = user.donations.first
      delete donation_path(id: donation.id), headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns deleted donation" do
      delete donation_path(id: donation.id), headers: admin_headers
      body = JSON.parse(response.body)
      data = body["data"]
      validate_donation_response(data, donation)
    end

    it "returns error message when error on destroying" do
      donation = user.donations.last
      allow(Adoption).to receive(:find).with(donation.id.to_s).and_return(donation)
      allow(donation).to receive(:destroy).and_return(false)

      delete donation_path(id: donation.id), headers: admin_headers
      
      body = JSON.parse(response.body)
      expect(Adoption).to have_received(:find)
      expect(donation).to have_received(:destroy)
      expect(body["error"]).to include(I18n.t("adotae.errors.donation.on_destroy"))
    end

    it "returns error message when not found" do
      delete donation_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.donation.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      delete donation_path(id: donation.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  def validate_donation_response(data, donation)
    expect(data["id"]).to               eq(donation.id)
    expect(data["giver_id"]).to         eq(donation.giver_id)
    expect(data["adopter_id"]).to       eq(donation.adopter_id)
    expect(data["associate_id"]).to     eq(donation.associate_id)
    expect(data["pet_id"]).to           eq(donation.pet_id)
    expect(data["status"]).to           eq(donation.status)
    expect(data["completed_at"]).to     eq(json_date(donation.completed_at))
    expect(data["created_at"]).to       eq(json_date(donation.created_at))
    expect(data["updated_at"]).to       eq(json_date(donation.updated_at))
  end

  def json_date(date)
    date&.strftime("%FT%X.%3NZ")
  end
end
