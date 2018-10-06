class Checklist < ActiveRecord::Base
  belongs_to :budget
  belongs_to :initiative
  belongs_to :author, class_name: 'User'

  has_many :items, class_name: 'ChecklistItem', dependent: :destroy
end
