class MentoringType < ActiveRecord::Base
    # validations
    validates :name,  presence: true
end
