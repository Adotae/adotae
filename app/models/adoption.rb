# frozen_string_literal: true

class Adoption < ApplicationRecord
  # Relations
  belongs_to :giver, class_name: 'User', foreign_key: 'giver_id'
  belongs_to :adopter, class_name: 'User', foreign_key: 'adopter_id', optional: true
  belongs_to :associate, optional: true
  belongs_to :pet

  # Scopes
  scope :complete, -> { where(status: 'complete') }

  def completed?
    status == 'completed'
  end
end
