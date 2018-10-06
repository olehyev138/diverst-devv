class AddDisableLikesToEnterprise < ActiveRecord::Migration
  def change
    add_column :enterprises, :disable_likes, :boolean, default: false
  end
end
