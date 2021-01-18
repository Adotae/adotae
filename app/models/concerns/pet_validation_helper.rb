# frozen_string_literals: true

module PetValidationHelper
  extend ActiveSupport::Concern

  private

  def kind_is_defined?
    return unless Pet::KINDS.exclude?(kind)
    errors.add(:kind, I18n.t("activerecord.errors.models.pet.attributes.kind.invalid"))
  end

  def breed_is_defined?
    return unless Pet::BREEDS.exclude?(breed)
    errors.add(:breed, I18n.t("activerecord.errors.models.pet.attributes.breed.invalid"))
  end

  def gender_is_defined?
    return unless Pet::GENDERS.exclude?(gender)
    errors.add(:gender, I18n.t("activerecord.errors.models.pet.attributes.gender.invalid"))
  end
end
