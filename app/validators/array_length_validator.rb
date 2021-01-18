# frozen_string_literals: true

class ArrayLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validate_options
    @array_size = value&.size || 0
    record.errors.add(attribute, :too_short, count: minimum) if too_short
    record.errors.add(attribute, :too_long, count: maximum) if too_long
  end

  private

  def validate_options
    return unless options.key?(:minimum) || options.key?(:in)
    return unless options.key?(:maximum) || options.key?(:in)
  end

  def too_short
    @array_size < minimum
  end

  def too_long
    @array_size > maximum
  end

  def minimum
    options[:minimum] || options[:in].begin
  end

  def maximum
    options[:maximum] || options[:in].end
  end
end
