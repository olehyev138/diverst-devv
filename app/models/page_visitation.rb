class PageVisitation < ActiveRecord::Base
  validates_length_of :action, maximum: 191
  validates_length_of :controller, maximum: 191
  validates_length_of :page_url, maximum: 191
  validates :page_url, uniqueness: { scope: :user_id }
  belongs_to :user
  belongs_to :page_name, class_name: 'PageName', foreign_key: 'page_url'

  def name
    page_name.page_name rescue nil
  end

  def name=(new_name)
    pn = page_name
    if pn.nil?
      pn = PageName.new(page_url: page_url)
    end
    pn.page_name = new_name
    pn.save
  end
end
