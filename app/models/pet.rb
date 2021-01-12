class Pet < ApplicationRecord
  include Rails.application.routes.url_helpers

  # Relations
  belongs_to :user
  has_many :favorited_pets, dependent: :destroy
  has_many :adoptions, dependent: :destroy

  has_many_attached :photos

  def size
    # TODO: Calculate pet size based on height and weight
    'small'
  end

  def in_adoption?
    adoptions.where(status: 'incomplete').any?
  end

  def get_photos_urls
    photos.map do |photo|
      url_for(photo)
    end
  end
end
