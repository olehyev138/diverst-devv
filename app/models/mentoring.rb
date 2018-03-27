class Mentoring < ActiveRecord::Base
    # associations
    belongs_to :mentee, :class_name => "Mentorship"
    belongs_to :mentor, :class_name => "Mentorship"
    
    # validations
    validates :mentor,  presence: true
    validates :mentee,  presence: true
end
