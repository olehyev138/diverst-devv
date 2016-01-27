class AddPicturesToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.attachment :picture
    end
  end
end
