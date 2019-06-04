class ConvertFieldsToPolymorphic < ActiveRecord::Migration[5.1]
  def change
    change_table :fields do |t|
      t.belongs_to :container, polymorphic: true, index: true
      t.remove :poll_id, :enterprise_id
    end
  end
end
