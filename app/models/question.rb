class Question < BaseClass
  include PublicActivity::Common

  belongs_to :campaign, counter_cache: true
  has_many :answers, inverse_of: :question, dependent: :destroy
  has_many :answer_comments, through: :answers, source: :comments

  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  validates_length_of :conclusion, maximum: 65535
  validates_length_of :description, maximum: 65535
  validates_length_of :title, maximum: 191
  validates :title,           presence: true
  validates :description,     presence: true
  validates :campaign,        presence: true

  scope :solved, -> { where.not(solved_at: nil) }
end
