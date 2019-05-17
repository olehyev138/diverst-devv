class AddArchiveAtAttributeToInitiatives < ActiveRecord::Migration[5.1]
  def change
  	add_column :initiatives, :archived_at, :datetime
  end
end
