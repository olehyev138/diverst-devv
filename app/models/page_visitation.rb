class PageVisitation < ActiveRecord::Base
  validates_length_of :action, maximum: 191
  validates_length_of :controller, maximum: 191
  validates_length_of :page_site, maximum: 191
  validates_length_of :page_name, maximum: 191
  validates :page_name, uniqueness: { scope: [:page_url, :user_id] }
  belongs_to :user
end
