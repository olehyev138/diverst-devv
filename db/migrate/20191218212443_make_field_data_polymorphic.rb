class MakeFieldDataPolymorphic < ActiveRecord::Migration[5.2]
  def up
    transaction do
      add_column :field_data, :fieldable_id, :bigint, first: true
      add_column :field_data, :fieldable_type, :string, after: :fieldable_id
      add_index :field_data, [:fieldable_id, :fieldable_type]

      FieldData.find_each do |fd|
        fd.fieldable = fd.user
        fd.save!
      end

      [InitiativeUpdate, GroupUpdate, UserGroup, PollResponse].each do |model|
        model.find_each do |item|
          info = item.info
          info.keys.each do |field_id|
            # - Find field object & extract data from hash (can only be done through field object)
            # - Serialize field data as json string
            field = Field.find(field_id)
            data_str = info[field].to_json

            # Create new FieldData object associated to current user & current field
            field_data = FieldData.new(
                fieldable: item,
                field_id: field_id,
                data: data_str
            )

            field_data.save!
          end
        end
      end

      remove_index :field_data, name: 'index_field_data_on_user_id'
      remove_column :field_data, :user_id
    end
  end

  def down
    transaction do
      FieldData.destroy_all
      ActiveRecord::Base.connection.execute("TRUNCATE field_data")
      User.all.each do |user|
        # For each field id in users data hash
        info = user.info
        info.keys.each do |field_id|
          # - Find field object & extract data from hash (can only be done through field object)
          # - Serialize field data as json string
          field = Field.find(field_id)
          data_str = info[field].to_json

          # Create new FieldData object associated to current user & current field
          field_data = FieldData.new(
              user_id: user.id,
              field_id: field_id,
              data: data_str
          )

          field_data.save!
        end
      end

      remove_index :field_data, name: 'index_field_data_on_fieldable_id_and_fieldable_type'
      remove_column :field_data, :fieldable_id
      remove_column :field_data, :fieldable_type
    end
  end
end
