class GroupUpdate < ActiveRecord::Base
  include PublicActivity::Common
  include ContainsFields

  belongs_to :owner, class_name: "User"
  belongs_to :group

  validates :created_at, presence: true

  # Returns the delta with another update relative to this other update for a particular field (+23%, -12%, etc.)
  def variance_with(other_update:, field:)
    value = self.info[field]
    value_to_compare = other_update.info[field]

    return nil if !value_to_compare

    abs_variance = value.to_i - value_to_compare.to_i
    rel_variance = abs_variance.to_f / value_to_compare
  end

  # Returns the delta (just like `variance_with`) with the last update for the specified field
  def variance_from_previous(field)
    return nil if !self.previous
    self.variance_with(other_update: self.previous, field: field)
  end

  # The next update in chronological order
  def next
    self.class.where(group: self.group).where("created_at > ?", self.created_at).order(created_at: :asc).first
  end

  # The previous update in chronological order
  def previous
    self.class.where(group: self.group).where("created_at < ?", self.created_at).order(created_at: :asc).last
  end
end
