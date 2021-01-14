require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  subject { UserPolicy.new(admin, user) }

  let(:user) { create(:user) }

  context "unauthenticated" do
    let(:admin) { nil }

    it { should_not permit(:me) }
    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for a user" do
    let(:admin) { user }

    it { should     permit(:me) }

    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for a manager" do
    let(:admin) { create(:manager) }

    it { should     permit(:index) }
    it { should     permit(:show) }
    it { should     permit(:create) }

    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
    it { should_not permit(:me) }
  end

  context "for a moderator" do
    let(:admin) { create(:moderator) }

    it { should     permit(:index) }
    it { should     permit(:show) }

    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
    it { should_not permit(:me) }
  end

  context "for an admin" do
    let(:admin) { create(:admin) }

    it { should     permit(:index) }
    it { should     permit(:show) }
    it { should     permit(:create) }
    it { should     permit(:update) }
    it { should     permit(:destroy) }

    it { should_not permit(:me) }
  end
end
