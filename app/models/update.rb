class Update < ApplicationRecord
  @@field_definer_name = 'updatable'
  @@field_association_name = 'fields'
  mattr_reader :field_association_name, :field_definer_name

  include Update::Actions

  after_save -> { UpdateNextAndPreviousUpdateJob.perform_now(id) }
  after_destroy -> { UpdateNextAndPreviousUpdateJob.perform_now(self.next.id) if self.next.present? }

  belongs_to :owner, class_name: 'User'
  belongs_to :updatable, polymorphic: true
  belongs_to :previous, class_name: 'Update', inverse_of: :next
  has_one :next, class_name: 'Update', foreign_key: 'previous_id', inverse_of: :previous
  has_many :field_data, class_name: 'FieldData', as: :field_user, dependent: :destroy

  accepts_nested_attributes_for :field_data
  include ContainsFieldData

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
    value = get_field_data(field).deserialized_data
    value_to_compare = other_update.get_field_data(field).deserialized_data

    return nil unless value_to_compare

    abs_variance = value - value_to_compare
    rel_variance = abs_variance.to_f / value_to_compare

    [abs_variance, rel_variance]
  end

  # Returns the delta (just like `variance_with`) with the last update for the specified field
  def variance_from_previous(field)
    return nil unless self.previous

    self.variance_with(other_update: self.previous, field: field)
  end

  # The next update in chronological order
  def raw_next
    self.class.where(updatable: updatable).where('report_date > ?', report_date).order(report_date: :asc).first
  end

  # The previous update in chronological order
  def raw_previous
    self.class.where(updatable: updatable).where('report_date < ?', report_date).order(report_date: :asc).last
  end

  def update_prev_and_next
    UpdateNextAndPreviousUpdateJob(id, update_next: true)
  end
end
