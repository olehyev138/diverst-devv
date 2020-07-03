class SurveysManager < ApplicationRecord
  self.table_name = 'survey_managers'

  # there is no entity called survey??
  belongs_to :survey
  belongs_to :user
end
