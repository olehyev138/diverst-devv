class TotalPageVisitationByName < ActiveRecord::Base
  self.primary_key = :page_name
  belongs_to :enterprise
end
