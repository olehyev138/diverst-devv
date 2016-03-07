class Initiative < ActiveRecord::Base
  belongs_to :pillar
  belongs_to :owner, class_name: "User"
  has_many :updates, class_name: "InitiativeUpdate", dependent: :destroy
  has_many :fields, as: :container, dependent: :destroy

  monetize :estimated_funding_cents
  monetize :actual_funding_cents

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
end
