class AddFieldsToEvents < ActiveRecord::Migration
  def change
    create_table :event_fields do |t|
      t.belongs_to :field
      t.belongs_to :event
    end
  end
end
