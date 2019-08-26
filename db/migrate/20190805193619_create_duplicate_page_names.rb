class CreateDuplicatePageNames < ActiveRecord::Migration
  def change
    create_view :duplicate_page_names
  end
end
