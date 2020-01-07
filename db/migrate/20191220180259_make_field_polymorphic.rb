class MakeFieldPolymorphic < ActiveRecord::Migration[5.2]
  def add_poly
    add_column :fields, :field_definer_id, :bigint, first: true
    add_column :fields, :field_definer_type, :string, after: :field_definer_id
    add_index :fields, [:field_definer_id, :field_definer_type]
  end

  def remove_poly
    remove_index :fields, [:field_definer_id, :field_definer_type]
    remove_column :fields, :field_definer_id
    remove_column :fields, :field_definer_type
  end

  def add_individual
    add_column :fields, :poll_id, :bigint, first: true
    add_column :fields, :initiative_id, :bigint, first: true
    add_column :fields, :group_id, :bigint, first: true
    add_column :fields, :enterprise_id, :bigint, first: true

    add_index :fields, [:enterprise_id]
    add_index :fields, [:group_id]
    add_index :fields, [:initiative_id]
    add_index :fields, [:poll_id]
  end

  def remove_individual
    remove_index :fields, column: [:enterprise_id]
    remove_index :fields, column: [:group_id]
    remove_index :fields, column: [:initiative_id]
    remove_index :fields, column: [:poll_id]
    remove_column :fields, :enterprise_id
    remove_column :fields, :group_id
    remove_column :fields, :initiative_id
    remove_column :fields, :poll_id
  end

  def up
    add_poly

    Field.find_each do |field|
      field.field_definer_id = field.group_id || field.poll_id || field.initiative_id || field.enterprise_id
      unless field.field_definer_id.present?
        remove_poly
        abort('No ID')
      end
      field.field_definer_type =
          if field.group_id
            'Group'
          elsif field.poll_id
            'Poll'
          elsif field.initiative_id
            'Initiative'
          elsif field.enterprise_id
            'Enterprise'
          else
            remove_poly
            abort('No ID')
          end
      field.save!
    end

    remove_individual
  end


  def down
    add_individual

    Field.find_each do |field|
      case field.field_definer_type
      when 'Enterprise'
        field.enterprise_id = field.field_definer_id
      when 'Group'
        field.group_id = field.field_definer_id
      when 'Poll'
        field.poll_id = field.field_definer_id
      when 'Initiative'
        field.initiative_id = field.field_definer_id
      else
        remove_individual
        abort('invalid field_definer type')
      end

      field.save!(validate: false)
    end

    remove_poly
  end
end
