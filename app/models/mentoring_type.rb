class MentoringType < ActiveRecord::Base
    # validations
    validates :name,  presence: true, uniqueness: {case_sensitive: false}
end
