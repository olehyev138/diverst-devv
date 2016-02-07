class CreateUsersSegments < ActiveRecord::Migration
  def change
    create_table :users_segments do |t|
      t.belongs_to :user
      t.belongs_to :segment
    end
  end
end
