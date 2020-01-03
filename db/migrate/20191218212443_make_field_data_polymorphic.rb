class MakeFieldDataPolymorphic < ActiveRecord::Migration[5.2]
  def up
    transaction do
      add_column :field_data, :field_user_id, :bigint, first: true
      add_column :field_data, :field_user_type, :string, after: :field_user_id
      add_index :field_data, [:field_user_id, :field_user_type]

      FieldData.find_each do |fd|
        fd.field_user_id = fd.user_id
        fd.field_user_type = 'User'
        fd.save!(validate: false)
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
                field_user: item,
                field_id: field_id,
                data: data_str
            )

            field_data.save!(validate: false)
          end
        end
      end

      remove_index :field_data, name: 'index_field_data_on_user_id'
      remove_column :field_data, :user_id
    end
  end

  def down
    transaction do
      add_column :field_data, :user_id, :bigint, first: true
      add_index :field_data, :user_id

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

          field_data.save!(validate: false)
        end
      end

      remove_index :field_data, name: 'index_field_data_on_field_user_id_and_field_user_type'
      remove_column :field_data, :field_user_id
      remove_column :field_data, :field_user_type
    end
  end
end
