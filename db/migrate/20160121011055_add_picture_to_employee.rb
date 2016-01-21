class AddPictureToEmployee < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.attachment :avatar
    end
  end
end
