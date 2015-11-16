class Question < ActiveRecord::Base
  belongs_to :campaign
  has_many :answers
end
