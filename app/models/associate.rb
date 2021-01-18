# frozen_string_literals

class Associate < ApplicationRecord
  # Relations
  has_many :adoptions, dependent: :destroy
end
