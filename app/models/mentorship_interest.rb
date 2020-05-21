class MentorshipInterest < BaseClass
  # associations
  belongs_to :user
  belongs_to :mentoring_interest

  # validations
  validates :user,                presence: true
  validates :mentoring_interest,  presence: true

  settings do
    mappings dynamic: false do
      indexes :user do
        indexes :enterprise_id, type: :integer
      end
      indexes :mentoring_interest do
        indexes :name, type: :keyword
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        include: {
          user: { only: [:enterprise_id] },
          mentoring_interest: { only: [:name] } }
      )
    )
  end
end
