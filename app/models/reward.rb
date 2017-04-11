class Reward < ActiveRecord::Base
  belongs_to :enterprise
  belongs_to :responsible, class_name: "User", foreign_key: "responsible_id"
  has_attached_file :picture, styles: { medium: '300x300>' }

  validates_attachment_content_type :picture, content_type: %r{\Aimage\/.*\Z}
  validates :enterprise, presence: true
  validates :points, numericality: { only_integer: true }, presence: true
  validates :label, presence: true
  validates :responsible, presence: true
end
