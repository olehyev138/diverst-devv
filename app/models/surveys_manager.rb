class SurveysManager < ApplicationRecord
  self.table_name = 'survey_managers'

  belongs_to :user
end
