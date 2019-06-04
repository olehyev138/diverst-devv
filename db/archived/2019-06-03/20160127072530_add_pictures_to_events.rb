class AddPicturesToEvents < ActiveRecord::Migration[5.1]
  def change
    change_table :events do |t|
      t.attachment :picture
    end
  end
end
