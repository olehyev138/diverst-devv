module ContainsFieldData
  extend ActiveSupport::Concern

  included do
    before_validation :transfer_info_to_data
  end

  def info
    return @info unless @info.nil?

    self.data = '{}' if data.nil?
    json_hash = JSON.parse(data)
    @info = Hash[json_hash.map { |k, v| [k.to_i, v] }] # Convert the hash keys to integers since they're strings after JSON parsing
    @info.extend(FieldDataDeprecated)
  end

  # Called before validation to presist the (maybe) edited info object in the DB
  def transfer_info_to_data
    self.data = JSON.generate @info unless @info.nil?
  end

  def fields
    fields_holder.fields
  end

  def fields_holder
    send(self.class.fields_holder_name)
  end

  def fields_holder_id
    send("#{self.class.fields_holder_name}_id")
  end

  def method_missing(method_name, *arg)
    if method_name[-1] == '='
      field_data = self.field_data
                       .includes(:field)
                       .references(:field)
                       .where(
                           'lower(fields.title) = ?',
                           method_name[0...-1].to_s.downcase.gsub('_', ' ')
                       ).limit(1)
      if field_data.present?
        pp arg[1]
        field_data[0].data = arg[0].to_json
        field_data[0].save!
      else
        super
      end
    else
      field_data = self.field_data
                       .includes(:field)
                       .references(:field)
                       .where(
                           'lower(fields.title) = ?',
                           method_name.to_s.downcase.gsub('_', ' ')
                       ).limit(1)
      if field_data.present?
        field_data[0].deserialized_data
      else
        super
      end
    end
  end
end
