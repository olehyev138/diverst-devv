class GenerateFieldData < ActiveRecord::Migration[5.1]
  def up
    # Generate a set of field data objects for each users `data/info` hash

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
  end

  def down
    FieldData.destroy_all
  end
end
