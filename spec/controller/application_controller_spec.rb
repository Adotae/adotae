require "rails_helper"

RSpec.describe "ApplicationController", type: :controller do
  subject { V1::ApplicationController.new }

  before(:each) do
    allow(subject).to receive(:handle_error)
  end

  describe ".record_not_found" do
    it "should handle UserNotFoundError" do
      validate_not_found_error_handling_for("User")
    end

    it "should handle AdminUserNotFoundError" do
      validate_not_found_error_handling_for("AdminUser")
    end

    it "should handle PetNotFoundError" do
      validate_not_found_error_handling_for("Pet")
    end

    it "should handle AdoptionNotFoundError" do
      validate_not_found_error_handling_for("Adoption")
    end

    it "should handle ResourceNotFoundError" do
      validate_not_found_error_handling_for("UnknownResource")
    end
  end

  describe ".record_not_destroyed" do
    it "should handle UserNotDestroyedError" do
      validate_not_destroyed_error_handling_for("User")
    end

    it "should handle AdminUserNotDestroyedError" do
      validate_not_destroyed_error_handling_for("AdminUser")
    end

    it "should handle PetNotDestroyedError" do
      validate_not_destroyed_error_handling_for("Pet")
    end

    it "should handle AdoptionNotDestroyedError" do
      validate_not_destroyed_error_handling_for("Adoption")
    end

    it "should handle ResourceNotDestroyedError" do
      validate_not_destroyed_error_handling_for("UnknownResource")
    end
  end

  def validate_not_found_error_handling_for(resource_name)
    ar_error = ActiveRecord::RecordNotFound.new(id = 1, model = resource_name)
    
    if resource_name == "UnknownResource"
      error = ApiErrors::ResourceErrors::ResourceNotFoundError
    else
      class_name = "ApiErrors::#{resource_name}Errors::#{resource_name}NotFoundError"
      error = class_name.constantize
    end

    expect(subject).to receive(:record_not_found).with(ar_error).and_call_original
    expect(subject).to receive(:handle_error).with(an_instance_of(error))

    subject.send(:record_not_found, ar_error)
  end

  def validate_not_destroyed_error_handling_for(resource_name)
    if resource_name == "UnknownResource"
      ar_error = ActiveRecord::RecordNotDestroyed.new(message = "", record = ApplicationRecord)
      error = ApiErrors::ResourceErrors::ResourceNotDestroyedError
    else
      resource = resource_name.constantize.new
      ar_error = ActiveRecord::RecordNotDestroyed.new(message = "", record = resource)
      class_name = "ApiErrors::#{resource_name}Errors::#{resource_name}NotDestroyedError"
      error = class_name.constantize
    end

    expect(subject).to receive(:record_not_destroyed).with(ar_error).and_call_original
    expect(subject).to receive(:handle_error).with(an_instance_of(error))

    subject.send(:record_not_destroyed, ar_error)
  end
end