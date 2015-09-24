class ChangeMatchDateFormat < ActiveRecord::Migration
  def change
    remove_column :matches, :both_accepted_at, :time
    add_column :matches, :both_accepted_at, :datetime
  end
end
