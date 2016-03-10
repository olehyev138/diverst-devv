class CreatePlanningModels < ActiveRecord::Migration
  def change
    create_table :outcomes do |t|
      t.string :name

      t.belongs_to :group

      t.timestamps null: false
    end

    create_table :pillars do |t|
      t.string :name
      t.string :value_proposition

      t.belongs_to :outcome

      t.timestamps null: false
    end

    create_table :initiatives do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.integer :estimated_funding
      t.integer :actual_funding

      t.belongs_to :owner
      t.belongs_to :pillar

      t.timestamps null: false
    end

    create_table :initiative_fields do |t|
      t.belongs_to :initiative
      t.belongs_to :field
    end

    create_table :initiative_updates do |t|
      t.text :data
      t.text :comments

      t.belongs_to :owner
      t.belongs_to :initiative

      t.timestamps null: false
    end

    create_table :initiative_users do |t|
      t.belongs_to :initiative
      t.belongs_to :user
    end

    create_table :initiative_groups do |t|
      t.belongs_to :initiative
      t.belongs_to :group
    end
  end
end
