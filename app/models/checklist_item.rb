class ChecklistItem < ActiveRecord::Base
  belongs_to :container, polimorphic: true
end
