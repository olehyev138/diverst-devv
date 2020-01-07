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
      u.field_data.find_each do |fd|
        if u.updatable_type == 'Initiative'
          if InitiativeUpdate.where(id: fd.field_user_id).any?
            fd.field_user = InitiativeUpdate.find(fd.field_user_id)
          else
            fd.field_user = InitiativeUpdate.create do |i_up|
              i_up.data = u.data
              i_up.comments = u.data
              i_up.owner = u.owner
              i_up.created_at = u.created_at
              i_up.report_date = u.report_date
              i_up.initiative = u.updatable
            end
          end
        elsif u.updatable_type == 'Group'
          if GroupUpdate.where(id: fd.field_user_id).any?
            fd.field_user = GroupUpdate.find(fd.field_user_id)
          else
            fd.field_user = GroupUpdate.create do |g_up|
              g_up.data = u.data
              g_up.comments = u.data
              g_up.owner = u.owner
              g_up.created_at = u.report_date
              g_up.group = u.updatable
            end
          end
        end
        fd.save
      end
    end
    drop_table :updates
  end
end
