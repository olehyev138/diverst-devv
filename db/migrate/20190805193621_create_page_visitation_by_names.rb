class CreatePageVisitationByNames < ActiveRecord::Migration[5.2]
  def change
    create_view :page_visitation_by_names
  end
end
