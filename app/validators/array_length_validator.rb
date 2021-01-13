# frozen_string_literals: true

class ArrayLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless options.key?(:minimum) || options.key?(:in)
    return unless options.key?(:maximum) || options.key?(:in)

    array_size = value.try(:size) || 0
    minimum = options[:minimum] || options[:in].begin
    maximum = options[:maximum] || options[:in].end

    record.errors.add(attribute, :too_short, count: minimum) if array_size < minimum
    record.errors.add(attribute, :too_long, count: maximum)  if array_size > maximum
  end
end