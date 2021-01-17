require 'rails_helper'

RSpec.describe Donation::AdoptionPolicy, type: :policy do
  subject { Donation::AdoptionPolicy.new(user, donation) }

  let(:donation) { create(:donation) }

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

    it { should_not permit(:show) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for giver user" do
    let(:user) { donation.giver }

    it { should     permit(:index) }
    it { should     permit(:show) }
    it { should     permit(:create) }

    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for an manager" do
    let(:user) { create(:manager) }

    it { should     permit(:index) }
    it { should     permit(:show) }

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
  end

  context "for an admin" do
    let(:user) { create(:admin) }

    it { should permit(:index) }
    it { should permit(:show) }
    it { should permit(:create) }
    it { should permit(:update) }
    it { should permit(:destroy) }
  end
end
