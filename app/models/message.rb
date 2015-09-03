class Message < ActiveRecord::Base
  belongs_to :author, class_name: "Employee"
  belongs_to :recipient, class_name: "Employee"
end
