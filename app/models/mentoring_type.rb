class MentoringType < BaseClass
    # validations
    validates :name,  presence: true, uniqueness: { case_sensitive: false, scope: :enterprise_id }
end
