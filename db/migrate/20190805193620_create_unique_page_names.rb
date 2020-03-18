class CreateUniquePageNames < ActiveRecord::Migration[5.2]
  def change
    create_view :unique_page_names
  end
end
