# frozen_string_literal: true

class ApplicationValidator
  include ActiveModel::Model
  include ActiveModel::Attributes

  def initialize(attributes = {})
    declared_attributes = self.class.attribute_types.keys.map(&:to_s)
    super(attributes.stringify_keys.slice(*declared_attributes))
  end

  def success?
    valid?
  end

  def failure?
    !success?
  end

  def to_h
    @to_h ||= attributes.with_indifferent_access
  end
end
