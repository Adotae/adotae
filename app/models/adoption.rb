# frozen_string_literal: true

class Adoption < ApplicationRecord
  # Relations
  belongs_to :user, foreign_key: 'giver_id'
  belongs_to :user, foreign_key: 'adopter_id'
  belongs_to :associate
  belongs_to :pet

  def completed?
    status == 'completed'
  end
end
