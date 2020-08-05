class IdeaCategory < ActiveRecord::Base
  belongs_to :enterprise
  has_many :answers

  validates :name, presence: true
end
