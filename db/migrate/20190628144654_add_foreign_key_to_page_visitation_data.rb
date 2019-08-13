class AddForeignKeyToPageVisitationData < ActiveRecord::Migration
  def change
    add_foreign_key :page_visitation_data,  :users
  end
end
