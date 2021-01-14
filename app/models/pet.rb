class Pet < ApplicationRecord
  include PetValidationHelper
  include Rails.application.routes.url_helpers

  # Validations
  validates :name, presence: true, length: { in: 1..255 }

  validates :kind, presence: true
  validate  :kind_is_defined?

  validates :breed, presence: true # TODO: Breed is valid for pet kind?
  validate  :breed_is_defined?

  validates :gender, presence: true
  validate  :gender_is_defined?

  validates :age,
            presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 100 }

  validates :height,
            presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 500 }

  validates :weight,
            presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 500000 }

  validates :neutered, inclusion: { in: [true, false] }

  validates :dewormed, inclusion: { in: [true, false] }

  validates :vaccinated, inclusion: { in: [true, false] }

  validates :photos, presence: true, array_length: { in: 1..6 }

  validates :description, length: { in: 10..1024, allow_blank: true }

  # Relations
  belongs_to :user
  has_many :favorited_pets, dependent: :destroy
  has_many :adoptions, dependent: :destroy

  has_many_attached :photos

  KINDS = %w[dog cat].freeze
  BREEDS = %w[shitzu].freeze
  GENDERS = %w[male female].freeze

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
