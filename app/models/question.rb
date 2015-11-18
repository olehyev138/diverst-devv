class Question < ActiveRecord::Base
  belongs_to :campaign
  has_many :answers, inverse_of: :question, dependent: :destroy
end
