class AddApprovedToInitiativeComments < ActiveRecord::Migration[5.1]
  def change
  	add_column :initiative_comments, :approved, :boolean, default: false
  end
end
