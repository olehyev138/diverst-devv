class CreatePageVisiations2 < ActiveRecord::Migration
  def change
    create_view :page_visitations
  end
end
