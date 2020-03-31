class CreatePageNames < ActiveRecord::Migration[5.2]
  def change
    create_table :page_names, id: false, primary_key: :page_url do |t|
      t.string :page_url
      t.string :page_name
    end
  end
end
