# frozen_string_literal: true

require "rails_helper"

RSpec.describe AdminUserPolicy, type: :policy do
  subject { AdminUserPolicy.new(user, admin) }

  let(:admin) { create(:admin_user) }

  context "unauthenticated" do
    let(:user) { nil }

    it { should_not permit(:me) }
    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for a user" do
    let(:user) { create(:user) }

    it { should_not permit(:me) }
    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for an manager" do
    let(:user) { create(:manager) }

    it { should     permit(:me) }

    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for an moderator" do
    let(:user) { create(:moderator) }

    it { should     permit(:me) }

    it { should_not permit(:index) }
    it { should_not permit(:show) }
    it { should_not permit(:create) }
    it { should_not permit(:update) }
    it { should_not permit(:destroy) }
  end

  context "for an admin" do
    let(:user) { create(:admin) }

    it { should permit(:me) }
    it { should permit(:index) }
    it { should permit(:show) }
    it { should permit(:create) }
    it { should permit(:update) }
    it { should permit(:destroy) }
  end
end
