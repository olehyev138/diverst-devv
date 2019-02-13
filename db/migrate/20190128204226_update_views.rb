class UpdateViews < ActiveRecord::Migration
  def up
    View.find_each do |view|
      view_count = view.view_count - 1
      
      view_count.times do
        View.create(view.attributes.except("id", "view_count", "created_at", "updated_at"))
      end
    end
    
    # remove the column
    remove_column :views, :view_count, :integer
  end
  
  def down
    # remove the column
    add_column :views, :view_count, :integer
  end
end
