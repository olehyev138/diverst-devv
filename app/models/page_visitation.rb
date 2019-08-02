class PageVisitation < ActiveRecord::Base
  validates :page_name, uniqueness: { scope: [:page_url, :user_id] }
  belongs_to :user
end
