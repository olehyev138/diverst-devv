class MentoringType < BaseClass
  # validations
  validates_length_of :name, maximum: 191
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :enterprise_id }
end
