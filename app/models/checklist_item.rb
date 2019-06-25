class ChecklistItem < BaseClass
  belongs_to :initiative
  belongs_to :checklist
  validates_length_of :title, maximum: 191
end
