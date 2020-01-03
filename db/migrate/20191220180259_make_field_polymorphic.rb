class MakeFieldPolymorphic < ActiveRecord::Migration[5.2]
  def up
    add_column :fields, :field_definer_id, :bigint, first: true
    add_column :fields, :field_definer_type, :string, after: :field_definer_id
    add_index :fields, [:field_definer_id, :field_definer_type]

    Field.find_each do |field|
      field.field_definer_id = field.group_id || field.poll_id || field.initiative_id || field.enterprise_id
      field.field_definer_type =
          if field.group_id
            'Group'
          elsif field.poll_id
            'Poll'
          elsif field.initiative_id
            'Initiative'
          elsif field.enterprise_id
            'Enterprise'
          end
      field.save!(validate: false)
    end

    remove_index :fields, column: [:enterprise_id]
    remove_index :fields, column: [:group_id]
    remove_index :fields, column: [:initiative_id]
    remove_index :fields, column: [:poll_id]
    remove_column :fields, :enterprise_id
    remove_column :fields, :group_id
    remove_column :fields, :initiative_id
    remove_column :fields, :poll_id
  end


  def down
    add_column :fields, :poll_id, :bigint, first: true
    add_column :fields, :initiative_id, :bigint, first: true
    add_column :fields, :group_id, :bigint, first: true
    add_column :fields, :enterprise_id, :bigint, first: true

    add_index :fields, [:enterprise_id]
    add_index :fields, [:group_id]
    add_index :fields, [:initiative_id]
    add_index :fields, [:poll_id]


    Field.find_each do |field|
      case field.field_definer_type
      when 'Enterprise'
        field.enterprise = field.field_definer
      when 'Group'
        field.group = field.field_definer
      when 'Poll'
        field.poll = field.field_definer
      when 'Initiative'
        field.initiative = field.field_definer
      else
        # type code here
      end

      field.save!(validate: false)
    end

    remove_index :fields, [:field_definer_id, :field_definer_type]
    remove_column :fields, :field_definer_id
    remove_column :fields, :field_definer_type
  end
end
