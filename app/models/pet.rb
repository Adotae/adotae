class Pet < ApplicationRecord
  # Relations
  belongs_to :user
  has_many :favorited_pets, dependent: :destroy
  has_many :adoptions, dependent: :destroy

  def in_adoption?
    adoptions.where(status: 'incomplete').any?
  end
end
