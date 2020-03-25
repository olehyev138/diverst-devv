class PageName < ActiveRecord::Base
  self.primary_key = 'page_url'
  has_many :visits, class_name: 'PageVisitationData', foreign_key: 'page_url'

  before_save :truncate_name

  def truncate_name
    self.page_name = self.page_name&.truncate(50)
  end
end
