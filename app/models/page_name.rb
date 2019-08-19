class PageName < ActiveRecord::Base
  self.primary_key = 'page_url'
  has_many :visits, class_name: 'PageVisitationData', foreign_key: 'page_url'
end
