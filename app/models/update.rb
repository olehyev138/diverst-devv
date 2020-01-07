class Update < ApplicationRecord
  @@field_definer_name = 'updatable'
  @@field_association_name = 'fields'
  mattr_reader :field_association_name, :field_definer_name

  include ContainsFieldData
  include Update::Actions

  belongs_to :owner, class_name: 'User'
  belongs_to :updatable, polymorphic: true
  has_many :field_data, class_name: 'FieldData', as: :field_user, dependent: :destroy

  validates_length_of :comments, maximum: 65535
  validates_length_of :data, maximum: 65535
  validates_presence_of :report_date
  validates_presence_of :updatable
  validates_uniqueness_of :report_date, scope: :updatable

  def reported_for_date
    report_date || created_at
  end

  # Returns the delta with another update relative to this other update for a particular field (+23%, -12%, etc.)
  def variance_with(other_update:, field:)
    value = self.info[field]
    value_to_compare = other_update.info[field]

    return nil unless value_to_compare

    abs_variance = value - value_to_compare
    rel_variance = abs_variance.to_f / value_to_compare
  end

  # Returns the delta (just like `variance_with`) with the last update for the specified field
  def variance_from_previous(field)
    return nil unless self.previous

    self.variance_with(other_update: self.previous, field: field)
  end

  # The next update in chronological order
  def next
    self.class.where(updatable: updatable).where('report_date > ?', report_date).order(report_date: :asc).first
  end

  # The previous update in chronological order
  def previous
    self.class.where(updatable: updatable).where('report_date < ?', report_date).order(report_date: :asc).last
  end
end
