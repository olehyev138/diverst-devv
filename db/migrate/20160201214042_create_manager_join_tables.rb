class CreateManagerJoinTables < ActiveRecord::Migration
  def change
    create_table :groups_managers do |t|
      t.belongs_to :group
      t.belongs_to :user
    end

    create_table :campaigns_managers do |t|
      t.belongs_to :campaign
      t.belongs_to :user
    end

    create_table :survey_managers do |t|
      t.belongs_to :survey
      t.belongs_to :user
    end
  end
end
