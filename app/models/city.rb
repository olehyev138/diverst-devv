class City < ActiveRecord::Base
  validates :name, presence: true, length: { in: 2..100 }
end
