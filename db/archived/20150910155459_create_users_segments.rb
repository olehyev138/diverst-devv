class CreateUsersSegments < ActiveRecord::Migration[5.1]
  def change
    create_table :users_segments do |t|
      t.belongs_to :user
      t.belongs_to :segment
    end
  end
end
