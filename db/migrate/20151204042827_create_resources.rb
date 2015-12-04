class CreateResources < ActiveRecord::Migration
  def up
    create_table :resources do |t|
      t.string :title
      t.belongs_to :container, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_attachment :resources, :file
  end

  def down
    drop_table :resources
  end
end
