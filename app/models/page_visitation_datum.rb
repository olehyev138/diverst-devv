class PageVisitationDatum < ActiveRecord::Base
  belongs_to :user

  def self.add_page_visits(user, visits)

  end
end
