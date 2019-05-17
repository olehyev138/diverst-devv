class ChangeChecklistItemToBePolimorphic < ActiveRecord::Migration[5.1]
  def change
    change_table :checklist_items do |t|
      t.belongs_to :container, polymorphic: true, index: true
      t.remove :checklist_id
    end
  end
end
