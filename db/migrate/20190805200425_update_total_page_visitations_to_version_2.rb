class UpdateTotalPageVisitationsToVersion2 < ActiveRecord::Migration
  def up
    create_view :total_page_visitations, version: 2
  end
  def down
    drop_view :total_page_visitations, revert_to_version: 2
  end
end
