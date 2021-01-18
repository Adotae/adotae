require 'rails_helper'

RSpec.describe PetPolicy, type: :policy do
  subject { PetPolicy.new(user, pet) }

  let(:pet) { create(:pet) }

  context "unauthenticated" do
    let(:user) { nil }

    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for a random user" do
    let(:user) { create(:user) }

    it { should     permit(:index) }
    it { should     permit(:create) }
    it { should     permit(:around) }
    it { should     permit(:favorites) }

    it { should_not permit(:show) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for owner user" do
    let(:user) { pet.user }

    it { should permit(:index) }
    it { should permit(:show) }
    it { should permit(:create) }
    it { should permit(:update) }
    it { should permit(:destroy) }
    it { should permit(:around) }
    it { should permit(:favorites) }
  end

  context "for an manager" do
    let(:user) { create(:manager) }

    it { should     permit(:index) }
    it { should     permit(:show) }
    it { should     permit(:around) }
    it { should     permit(:favorites) }

    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for an moderator" do
    let(:user) { create(:moderator) }

    it { should     permit(:index) }
    it { should     permit(:show) }

    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
    it { should_not permit(:around) }
    it { should_not permit(:favorites) }
  end

  context "for an admin" do
    let(:user) { create(:admin) }

    it { should permit(:index) }
    it { should permit(:show) }
    it { should permit(:create) }
    it { should permit(:update) }
    it { should permit(:destroy) }
    it { should permit(:around) }
    it { should permit(:favorites) }
  end
end
