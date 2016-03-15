class Outcome < ActiveRecord::Base
  belongs_to :group
  has_many :pillars, dependent: :destroy

  accepts_nested_attributes_for :pillars, reject_if: :all_blank, allow_destroy: true
end
