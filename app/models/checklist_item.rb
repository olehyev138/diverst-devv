class ChecklistItem < ActiveRecord::Base
  belongs_to :initiative
  belongs_to :checklist
end
