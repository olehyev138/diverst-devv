class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.references  :taggable, :polymorphic => :true
      t.string    :name, :null => false
      t.timestamps null: false
    end
  end
end
