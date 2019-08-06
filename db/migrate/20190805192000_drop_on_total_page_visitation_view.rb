class DropOnTotalPageVisitationView < ActiveRecord::Migration
  def change
    drop_view :total_page_visitations, revert_to_version: 1
  end
end
