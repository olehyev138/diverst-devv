class ChecklistItem < ApplicationRecord
  belongs_to :initiative
  belongs_to :checklist
end
