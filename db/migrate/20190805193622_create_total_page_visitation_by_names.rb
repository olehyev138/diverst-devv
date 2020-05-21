class CreateTotalPageVisitationByNames < ActiveRecord::Migration
  def change
    create_view :total_page_visitation_by_names
  end
end
