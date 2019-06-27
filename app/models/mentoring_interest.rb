class MentoringInterest < BaseClass
  # associations
  has_many :mentorship_interests
  has_many :users, through: :mentorship_interests

  # validations
  validates_length_of :name, maximum: 191
  validates :name,  presence: true

  # we downcase the name in order to allow for searching
  before_save { |m| m.name = m.name.downcase }
end
