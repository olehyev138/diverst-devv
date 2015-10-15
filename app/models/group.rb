class Group < ActiveRecord::Base
  has_and_belongs_to_many :members, class_name: "Employee"
  belongs_to :enterprise
  has_and_belongs_to_many :polls
  has_many :events
  has_many :messages, class_name: "GroupMessage"

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ActionController::Base.helpers.image_path("missing.png")
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/
end
