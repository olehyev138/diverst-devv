class InitiativeUpdate < ApplicationRecord
  FIELD_DEFINER_NAME = :initiative
  FIELD_ASSOCIATION_NAME = :fields

  belongs_to :initiative
  include ContainsFieldData

  belongs_to :owner, class_name: 'User'

  validates_length_of :comments, maximum: 65535
  validates_length_of :data, maximum: 65535
  def reported_for_date
    report_date || created_at
  end

  # Returns the delta with another update relative to this other update for a particular field (+23%, -12%, etc.)
  def variance_with(other_update:, field:)
    value = self[field]
    value_to_compare = other_update[field]

    return nil if !value_to_compare

    abs_variance = value - value_to_compare
    rel_variance = abs_variance.to_f / value_to_compare
  end

  # Returns the delta (just like `variance_with`) with the last update for the specified field
  def variance_from_previous(field)
    return nil if !self.previous

    self.variance_with(other_update: self.previous, field: field)
  end

  # The next update in chronological order
  def next
    self.class.where(initiative: self.initiative).where('created_at > ?', self.created_at).order(created_at: :asc).first
  end

  # The previous update in chronological order
  def previous
    self.class.where(initiative: self.initiative).where('created_at < ?', self.created_at).order(created_at: :asc).last
  end
end
