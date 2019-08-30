class TotalPageVisitation < ActiveRecord::Base
  self.primary_key = :page_url
  belongs_to :enterprise
end
