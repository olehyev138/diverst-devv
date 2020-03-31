class CreatePageVisiations2 < ActiveRecord::Migration[5.2]
  def change
    create_view :page_visitations
  end
end
