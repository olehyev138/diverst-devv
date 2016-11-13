class Checklist < ActiveRecord::Base
  belongs_to :subject, polymorphic: true

  belongs_to :author, class_name: 'User'

  has_many :items, class_name: 'ChecklistItem', as: :container
end
