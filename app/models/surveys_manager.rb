class SurveysManager < ApplicationRecord
  self.table_name = 'survey_managers'

  belongs_to :survey  #there is no entity called survey??
  belongs_to :user
end
