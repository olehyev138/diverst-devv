class Mentoring < ActiveRecord::Base
    # associations
    belongs_to :mentee, :class_name => "User"
    belongs_to :mentor, :class_name => "User"
    
    # validations
    validates :mentor,  presence: true
    validates :mentee,  presence: true
end
