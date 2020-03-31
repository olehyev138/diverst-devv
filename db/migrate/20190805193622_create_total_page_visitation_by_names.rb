class CreateTotalPageVisitationByNames < ActiveRecord::Migration[5.2]
  def change
    create_view :total_page_visitation_by_names
  end
end
