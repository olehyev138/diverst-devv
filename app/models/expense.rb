class Expense < ActiveRecord::Base
  belongs_to :enterprise

  def self.categories
    ["Other", "Travel", "HR"]
  end
end