require "rails_helper"

RSpec.describe ApplicationPolicy, type: :policy do
  subject { ApplicationPolicy.new(user, record) }

  let(:record) { create(:user) }

  context "unauthenticated" do
    let(:user) { nil }

    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for a user" do
    let(:user) { record }

    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for an admin" do
    let(:user) { create(:admin) }

    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end
end