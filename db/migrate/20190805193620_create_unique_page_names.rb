class CreateUniquePageNames < ActiveRecord::Migration
  def change
    create_view :unique_page_names
  end
end
