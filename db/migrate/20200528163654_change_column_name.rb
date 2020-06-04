class ChangeColumnName < ActiveRecord::Migration[5.2]
  def up
    rename_column :enterprises, :disable_likes, :enable_likes
    change_column_default :enterprises, :enable_likes, from: false, to: true
    Enterprise.update_all("enable_likes = NOT enable_likes")
  end
  def down
    rename_column :enterprises, :enable_likes, :disable_likes
    change_column_default :enterprises, :disable_likes, from: true, to: false
    Enterprise.update_all("disable_likes = NOT disable_likes")
  end
end
