class PageVisitationData < ActiveRecord::Base
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

  def self.end_of_day_count
    find_each do |vst|
      %w(week month year).each do |frame|
        if vst.created_at < 1.send(frame).ago
          eval "vst.visits_#{frame} -= #{vst.visits_day}"
        end
        vst.visits_day = 0
        vst.save
      end
    end
  end
end
