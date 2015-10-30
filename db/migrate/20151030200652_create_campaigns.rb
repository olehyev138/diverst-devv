class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.datetime :start
      t.datetime :end
      t.integer :nb_invites

      t.belongs_to :enterprise

      t.timestamps null: false
    end
  end
end
