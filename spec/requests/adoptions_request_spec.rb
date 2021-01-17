require 'rails_helper'

RSpec.describe "Adoptions", type: :request do
  
  #let(:user) { create(:user_with_adoptions) }
  let!(:admin) { create(:admin) }
  #let(:user_tokens) { jwt_and_refresh_token(user, "user") }
  let!(:admin_tokens) { jwt_and_refresh_token(admin, "admin_user") }
  #let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}
  let!(:admin_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{admin_tokens[0]}" }}

  describe "GET adoptions#index" do
    let(:user) { create(:user_with_adoptions) }
    let(:user_tokens) { jwt_and_refresh_token(user, "user") }
    let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}

    before { get adoptions_path }

    it "is a success when authenticated" do
      get adoptions_path, headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns all user adoptions" do
      get adoptions_path, headers: user_headers
      
      body = JSON.parse(response.body)
      expect(body["data"].size).to eq(user.adoptions.size)
    end

    it "returns all adoptions for a specific user" do
      get adoptions_path, params: { user: user.id }, headers: admin_headers

      body = JSON.parse(response.body)
      expect(body["data"].size).to eq(user.adoptions.size)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when specified user doesn't exist" do
      get adoptions_path, params: { user: 999 }, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.not_found"))
    end
  end

  describe "GET adoptions#show" do  
    let(:user) { create(:user_with_adoptions) }
    let(:user_tokens) { jwt_and_refresh_token(user, "user") }
    let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}

    before { get adoption_path(id: user.adoptions.first.id) }

    it "is a success when authenticated" do
      get adoption_path(id: user.adoptions.first.id), headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns specified adoption if user owns it" do
      adoption = user.adoptions.first

      get adoption_path(id: adoption.id), headers: user_headers
      
      body = JSON.parse(response.body)
      data = body["data"]
      validate_adoption_response(data, adoption)
    end

    it "returns specified adoption if admin user" do
      adoption = user.adoptions.first

      get adoption_path(id: adoption.id), headers: admin_headers
      
      body = JSON.parse(response.body)
      data = body["data"]
      validate_adoption_response(data, adoption)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message if user doesn't owns it" do
      adoption = create(:adoption)
      get adoption_path(id: adoption.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end

    it "returns error message when specified adoption doesn't exist" do
      get adoption_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.adoption.not_found"))
    end
  end

  describe "POST adoptions#create" do  
    let(:user) { create(:user_with_adoptions) }
    let(:user_tokens) { jwt_and_refresh_token(user, "user") }
    let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}

    let!(:adoption) { create(:adoption) }

    let!(:pet) { create(:pet_in_donation) }
    let!(:params) {{
      pet_id: pet.id
    }}

    before { post adoptions_path, params: params }

    it "is a success when authenticated and valid params" do
      post adoptions_path, params: params, headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      post adoptions_path, params: {}, headers: user_headers
      expect(response).to have_http_status(:not_found)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns created adoption" do
      post adoptions_path, params: params.merge({ user_id: user.id }), headers: admin_headers
      body = JSON.parse(response.body)
      data = body["data"]
      created_adoption = Adoption.find(data["id"])
      validate_adoption_response(data, created_adoption)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end
  end

  describe "PUT adoptions#update" do    
    let(:user) { create(:user_with_adoptions) }
    let(:user_tokens) { jwt_and_refresh_token(user, "user") }
    let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}

    let!(:adoption) { user.adoptions.last }
    let!(:params) {{
      status: "complete",
      completed_at: "2020-01-14T10:44:32.431Z"
    }}

    before { put adoption_path(id: adoption.id), params: params }

    it "is a success when authenticated and valid params" do
      put adoption_path(id: adoption.id), params: params, headers: admin_headers
      adoption.reload
      params.merge!({
        id: adoption.id,
        giver_id: adoption.giver_id,
        adopter_id: adoption.adopter_id,
        associate_id: adoption.associate_id,
        pet_id: adoption.pet_id,
        created_at: adoption.created_at,
        updated_at: adoption.updated_at
      })
      validate_adoption_response(JSON.parse(params.to_json), adoption)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      params[:status] = "unknown_status"
      put adoption_path(id: adoption.id), params: params, headers: admin_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      put adoption_path(id: adoption.id), params: params, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns updated adoption" do
      put adoption_path(id: adoption.id), params: params, headers: admin_headers
      adoption.reload
      body = JSON.parse(response.body)
      data = body["data"]
      validate_adoption_response(data, adoption)
    end

    it "returns error message when not found" do
      put adoption_path(id: 999), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.adoption.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      put adoption_path(id: adoption.id), params: params, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "DELETE adoptions#destroy" do
    let(:user) { create(:user_with_adoptions) }
    let(:user_tokens) { jwt_and_refresh_token(user, "user") }
    let(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}
    let!(:adoption) { create(:adoption) }

    before { delete adoption_path(id: user.adoptions.last.id) }

    it "is a success when authenticated and authorized" do
      adoption = user.adoptions.first
      delete adoption_path(id: adoption.id), headers: admin_headers
      expect { Adoption.find(adoption.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      adoption = user.adoptions.first
      delete adoption_path(id: adoption.id), headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns deleted adoption" do
      delete adoption_path(id: adoption.id), headers: admin_headers
      body = JSON.parse(response.body)
      data = body["data"]
      validate_adoption_response(data, adoption)
    end

    it "returns error message when error on destroying" do
      adoption = user.adoptions.last
      allow(Adoption).to receive(:find).with(adoption.id.to_s).and_return(adoption)
      allow(adoption).to receive(:destroy).and_return(false)

      delete adoption_path(id: adoption.id), headers: admin_headers
      
      body = JSON.parse(response.body)
      expect(Adoption).to have_received(:find)
      expect(adoption).to have_received(:destroy)
      expect(body["error"]).to include(I18n.t("adotae.errors.adoption.on_destroy"))
    end

    it "returns error message when not found" do
      delete adoption_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.adoption.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      delete adoption_path(id: adoption.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  def validate_adoption_response(data, adoption)
    expect(data["id"]).to               eq(adoption.id)
    expect(data["giver_id"]).to         eq(adoption.giver_id)
    expect(data["adopter_id"]).to       eq(adoption.adopter_id)
    expect(data["associate_id"]).to     eq(adoption.associate_id)
    expect(data["pet_id"]).to           eq(adoption.pet_id)
    expect(data["status"]).to           eq(adoption.status)
    expect(data["completed_at"]).to     eq(json_date(adoption.completed_at))
    expect(data["created_at"]).to       eq(json_date(adoption.created_at))
    expect(data["updated_at"]).to       eq(json_date(adoption.updated_at))
  end

  def json_date(date)
    date&.strftime("%FT%X.%3NZ")
  end
end
