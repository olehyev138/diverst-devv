class UpdateSerializer < ApplicationRecordSerializer
  attributes :field_data, :next_id

  def serialize_all_fields
    true
  end

  def next_id
    object.next&.id
  end

  def field_data
    object.field_data.map do |fd|
      fd_hash = FieldDataSerializer.new(fd).as_json
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
