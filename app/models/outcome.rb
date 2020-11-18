class Outcome < ApplicationRecord
  include Outcome::Actions
  belongs_to :group
  has_many :pillars, dependent: :destroy, inverse_of: :outcome

  accepts_nested_attributes_for :pillars, reject_if: :all_blank, allow_destroy: true
  validates_length_of :name, maximum: 191
  validates :name, presence: true

  # Gets all initiatives for outcome
  def get_initiatives
    pillars.map { |p| p.initiatives.to_a }.flatten
  end

  # Gets all initiatives for a collection of outcomes
  def self.get_initiatives(outcomes)
    outcomes.map { |o| o.get_initiatives }.flatten
  end
end
