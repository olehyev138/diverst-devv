class AddEventUrlToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :event_url, :string
  end
end
