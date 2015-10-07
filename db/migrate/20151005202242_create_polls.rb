class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.text :description
      t.time :start
      t.time :end
      t.integer :nb_invitations
      t.belongs_to :enterprise

      t.timestamps null: false
    end
  end
end
