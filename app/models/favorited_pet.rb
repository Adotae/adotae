class FavoritedPet < ApplicationRecord
  # Relations
  belongs_to :user
  belongs_to :pet
end
