class Question < ActiveRecord::Base
    belongs_to :campaign
    has_many :answers, inverse_of: :question, dependent: :destroy
    has_many :answer_comments, through: :answers, source: :comments

    accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

    validates :title,           presence: true
    validates :description,     presence: true
    validates :campaign,        presence: true

    scope :solved, -> { where.not(solved_at: nil) }
end
