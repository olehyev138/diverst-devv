class UpdateTotalPageVisitationByNamesToVersion2 < ActiveRecord::Migration
  def change
    update_view :total_page_visitation_by_names, version: 2, revert_to_version: 1
  end
end
