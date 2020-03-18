class Mentoring < ApplicationRecord
  include PublicActivity::Common
  include Mentoring::Actions

  # associations
  belongs_to :mentee, class_name: 'User', counter_cache: :mentors_count
  belongs_to :mentor, class_name: 'User', counter_cache: :mentees_count

  # validations
  validates   :mentor,  presence: true
  validates   :mentee,  presence: true

  # only allow one unique mentor per mentee
  validates_uniqueness_of :mentor, scope: [:mentee]

  def self.active_mentorships(enterprise)
    mentorship_user_ids = enterprise.users.ids
    where('mentor_id IN (?) OR mentee_id IN (?)', mentorship_user_ids, mentorship_user_ids)
  end

  settings do
    mappings dynamic: false do
      indexes :mentor do
        indexes :enterprise_id, type: :integer
        indexes :active, type: :boolean
        indexes :id, type: :integer
      end
      indexes :mentee do
        indexes :enterprise_id, type: :integer
        indexes :active, type: :boolean
        indexes :id, type: :integer
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [],
        include: {
          mentor: {
            only: [:enterprise_id, :active, :id]
          },
          mentee: {
            only: [:enterprise_id, :active, :id]
          }
        }
      )
    )
  end
end
