class AddEventUrlToInitiatives < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :initiatives, :event_url
      add_column :initiatives, :event_url, :string
    end
  end
end
