class MentoringSession < ActiveRecord::Base
    # validations
    validates :start,   presence: true
    validates :end,     presence: true
    validates :status,  presence: true
end
