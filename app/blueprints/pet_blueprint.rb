class PetBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :kind, :breed, :gender, :age, :height, :weight, :neutered,
         :dewormed, :vaccinated, :description, :can_be_adopted

  field :size do |pet, _options|
    pet.size
  end

  field :photos do |pet, _options|
    pet.photos_urls
  end
end
