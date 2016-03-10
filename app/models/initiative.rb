class Initiative < ActiveRecord::Base
  belongs_to :pillar
  belongs_to :owner, class_name: "User"
  has_many :updates, class_name: "InitiativeUpdate", dependent: :destroy
  has_many :fields, as: :container, dependent: :destroy
  has_many :expenses, dependent: :destroy, class_name: "InitiativeExpense"

  accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
end
