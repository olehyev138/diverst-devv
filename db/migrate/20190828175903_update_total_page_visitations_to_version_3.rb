class UpdateTotalPageVisitationsToVersion3 < ActiveRecord::Migration[5.2]
  def change
    update_view :total_page_visitations, version: 3, revert_to_version: 2
  end
end
