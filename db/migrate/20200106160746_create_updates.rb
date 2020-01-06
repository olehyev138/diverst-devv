class CreateUpdates < ActiveRecord::Migration[5.2]
  def up
    create_table :updates do |t|
      t.text :data
      t.text :comments
      t.date :report_date, index: true

      t.references :owner
      t.references :updatable, polymorphic: true

      t.timestamps
    end

    [GroupUpdate, InitiativeUpdate].each do |klass|
      klass.find_each do |old_u|
        Update.create do |new_u|
          new_u.data = old_u.data
          new_u.comments = old_u.comments
          new_u.owner = old_u.owner
          new_u.created_at = old_u.created_at
          if klass == GroupUpdate
            new_u.updatable = old_u.group
            new_u.report_date = old_u.created_at
          elsif klass == InitiativeUpdate
            new_u.updatable = old_u.initiative
            new_u.report_date = old_u.reported_for_date
          end
          old_u.field_data.find_each do |fd|
            fd.field_user = new_u
            fd.save
          end
        end
      end
    end
  end

  def down
    Update.find_each do |u|
      field_data.update do |fd|
        if u.updatable_type == 'Initiative'
          fd.field_user = InitiativeUpdate.find(fd.field_user_id)
        elsif u.updatable_type == 'Group'
          fd.field_user = GroupUpdate.find(fd.field_user_id)
        end
        fd.save
      end
    end
    drop_table :updates
  end
end
