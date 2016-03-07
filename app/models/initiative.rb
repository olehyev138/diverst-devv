class Initiative < ActiveRecord::Base
  belongs_to :pillar
  belongs_to :owner, class_name: "User"
  has_many :initiative_updates
  has_many :updates, through: :initiative_updates, source: :initiative
  has_many :fields, as: :container

  monetize :estimated_funding_cents
  monetize :actual_funding_cents
end
