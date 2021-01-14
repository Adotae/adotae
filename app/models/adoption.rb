# frozen_string_literal: true

class Adoption < ApplicationRecord
  before_validation :set_initial_status, on: :create

  # Validations
  validates :status, presence: true
  validate  :status_is_defined?, on: :update
  
  validates :completed_at, absence: true, on: :create

  # Relations
  belongs_to :giver, class_name: "User", foreign_key: "giver_id"
  belongs_to :adopter, class_name: "User", foreign_key: "adopter_id", optional: true
  belongs_to :associate, optional: true
  belongs_to :pet

  # Scopes
  scope :incomplete, -> { where(status: "incomplete") }
  scope :complete, -> { where(status: "complete") }

  STATUS = %w[incomplete complete].freeze

  def completed?
    status == "complete"
  end

  private

  def set_initial_status
    self.status = "incomplete"
  end

  def status_is_defined?
    return unless STATUS.exclude?(status)
    errors.add(:status, I18n.t("activerecord.errors.models.adoption.attributes.status.invalid"))
  end
end
