class Expense < ActiveRecord::Base
  belongs_to :enterprise

  def self.categories
    ["Capital", "Office supplies", "Transportation", "Shipping", "Information technology", "Telecommunications", "Labor", "Real estate", "Services", "Training"]
  end

  def icon_name
    self.category.parameterize
  end
end