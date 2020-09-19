class AddEmailContentToSuggestHires < ActiveRecord::Migration
  def change
    add_column :suggested_hires, :message_to_manager, :text
  end
end
