class UpdateSerializer < ApplicationRecordSerializer
  attributes_with_permission :field_data, :next_id, if: :singular_action?

  def serialize_all_fields
    true
  end

  def next_id
    object.next&.id
  end

  def field_data
    data = if object.new_record?
      object.field_data
    elsif object.field_data.loaded
      object.field_data.sort(&:field_id)
    else
      object.field_data.order(:field_id)
    end

    data.map do |fd|
      fd_hash = FieldDataSerializer.new(fd, **instance_options).as_json
      variance = object.variance_from_previous(fd.field)
      fd_hash[:var_with_prev] = variance
      fd_hash[:percent_var_with_prev] = variance ? "#{(variance * 100).round(1)}%" : nil
      fd_hash
    end
  end

  def excluded_keys
    [:updatable_type, :updatable_id]
  end
end
