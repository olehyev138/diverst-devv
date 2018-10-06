class AddApprovedToInitiativeComments < ActiveRecord::Migration
  def change
  	add_column :initiative_comments, :approved, :boolean, default: false
  end
end
