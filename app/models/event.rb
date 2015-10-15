class Event < ActiveRecord::Base
  has_and_belongs_to_many :segments
  belongs_to :group

  scope :past, -> { where('end < ?', Time.now) }
  scope :upcoming, -> { where('end >= ?', Time.now) }
end
