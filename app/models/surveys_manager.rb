class SurveysManager < ActiveRecord::Base
  belongs_to :survey
  belongs_to :employee
end