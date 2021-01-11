# frozen_string_literals: true

module AccountValidatable
  extend ActiveSupport::Concern

  private

  def cpf_is_valid?
    return if cpf.blank?
    return if cpf.match(/\A\d+\Z/) && CPF.valid?(cpf)
    model = self.class.name.downcase
    errors.add(:cpf, I18n.t("activerecord.errors.models.#{model}.attributes.cpf.invalid"))
  end

  def cnpj_is_valid?
    return if cnpj.blank?
    return if cnpj.match(/\A\d+\Z/) && CNPJ.valid?(cnpj)
    model = self.class.name.downcase
    errors.add(:cnpj, I18n.t("activerecord.errors.models.#{model}.attributes.cnpj.invalid"))
  end
end