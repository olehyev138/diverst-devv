class CreateDuplicatePageNames < ActiveRecord::Migration[5.2]
  def change
    create_view :duplicate_page_names
  end
end
