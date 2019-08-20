class CreateTotalPageVisitations < ActiveRecord::Migration
  def change
    create_view :total_page_visitations
  end
end
