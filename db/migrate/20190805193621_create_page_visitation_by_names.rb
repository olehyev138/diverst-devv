class CreatePageVisitationByNames < ActiveRecord::Migration
  def change
    create_view :page_visitation_by_names
  end
end
