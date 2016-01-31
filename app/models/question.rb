class Question < ActiveRecord::Base
  belongs_to :campaign
  has_many :answers, inverse_of: :question, dependent: :destroy
  has_many :answer_comments, through: :answers, source: :comments

  scope :solved, -> { where.not(solved_at: nil) }
end
