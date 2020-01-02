module ContainsFieldData
  extend ActiveSupport::Concern

  included do
    before_validation :transfer_info_to_data
    after_create :create_missing_field_data
    extend ClassMethods
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
    field_definer.send(self.class.field_association_name) if field_definer
  end

  def field_definer
    send(self.class.field_definer_name)
  end

  def field_definer_id
    send("#{self.class.field_definer_name}_id")
  end

  def load_field_data
    field_data.includes(:field).find_each do |fd|
      singleton_class.send(:define_method, fd.field.title.gsub(' ', '_').downcase) do
        fd.deserialized_data
      end

      singleton_class.send(:define_method, "#{fd.field.title.gsub(' ', '_').downcase}=") do |*args|
        fd.data = args[0].to_json
        fd.save!
      end
    end
  end

  def create_missing_field_data(*ids)
    from_field_holder = ids.present? ? fields.where(fields: { id: ids }) : fields || []
    from_field_data = field_data.includes(:field).map(&:field)

    missing = from_field_holder - from_field_data
    missing.each do |fld|
      field_data << FieldData.new(fieldable: self, field: fld)
    end
  end

  module ClassMethods
    def load_field_data
      # rubocop:disable Rails/FindEach
      includes(:field_data, field_data: :field).each do |u|
        u.field_data.each do |fd|
          u.singleton_class.send(:define_method, fd.field.title.gsub(' ', '_').downcase) do
            fd.deserialized_data
          end

          u.singleton_class.send(:define_method, "#{fd.field.title.gsub(' ', '_').downcase}=") do |*args|
            fd.data = args[0].to_json
            fd.save!
          end
        end
      end
      # rubocop:enable Rails/FindEach
    end
  end
end
