class ChecklistItem < ActiveRecord::Base
  belongs_to :container, polymorphic: true
end
