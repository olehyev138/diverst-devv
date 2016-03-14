class Pillar < ActiveRecord::Base
  belongs_to :outcome
  has_many :initiatives, dependent: :destroy
end