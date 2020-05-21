class AddArchiveAtAttributeToInitiatives < ActiveRecord::Migration
  def change
    add_column :initiatives, :archived_at, :datetime
  end
end
