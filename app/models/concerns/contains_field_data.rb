# Module to include Models which uses FieldData, containing needed functions and callbacks
module ContainsFieldData
  extend ActiveSupport::Concern

  included do
    before_validation :transfer_info_to_data
    after_create :create_missing_field_data
    extend ClassMethods
  end

  # LEGACY: POSSIBLY DEPRECATED
  def info
    return @info unless @info.nil?

    self.data = '{}' if data.nil?
    json_hash = JSON.parse(data)
    @info = Hash[json_hash.map { |k, v| [k.to_i, v] }] # Convert the hash keys to integers since they're strings after JSON parsing
    @info.extend(FieldDataDeprecated)
  end

  def [](key)
    case key
    when Symbol, String then super(key)
    when Field then field_data.find_by(field: key).deserialized_data
    else raise ArgumentError
    end
  end

  def []=(key, value)
    case key
    when Symbol, String then super(key, value)
    when Field then field_data.find_by(field: key).update(data: key.serialize_value(value))
    else raise ArgumentError
    end
  end

  # LEGACY: POSSIBLY DEPRECATED
  # Called before validation to presist the (maybe) edited info object in the DB
  def transfer_info_to_data
    self.data = JSON.generate @info unless @info.nil?
  end

  # Returns the fields a field_user can use
  #
  # @author Alex Oxorn
  #
  # @return [Field::ActiveRecord_Associations_CollectionProxy] List of Fields
  # @return [Field::ActiveRecord_Relation] Field.none if +field_definer+ doesn't exist
  #
  # @example
  #    u = User.first
  #    u.fields #=> [< Gender Field >, < D.O.B. Field > ...]
  def fields
    field_definer ? field_definer.send(self.class.field_association_name) : Field.none
  end

  # Returns the object which defines the fields a field_user can use
  #
  # @author Alex Oxorn
  #
  # @return [FieldDefiner] The FieldDefiner of a FieldUser
  # @return [nil] if there is no field_definer
  #
  # @example
  #    u = User.first  #=> < #User enterprise_id: 1>
  #    u.field_definer #=> < #Enterprise id: 1 >
  def field_definer
    send(self.class.field_definer_name)
  end

  # Returns the id of the field_definer which defines the fields a field_user can use
  #
  # @author Alex Oxorn
  #
  # @return [Integer] The FieldDefiner's id
  # @return [nil] if there is no field_definer
  #
  # @example
  #    u = User.first #=> < #User enterprise_id: 1>
  #    u.field_definer #=> 1
  def field_definer_id
    send("#{self.class.field_definer_name}_id")
  end

  # Creates getter and setter methods on a singleton of a +field_user+ for its +field_data+
  #
  # @author Alex Oxorn
  #
  # @return [void]
  #
  # @example
  #   u = User.first
  #   u.gender #=> raises < #NoMethodError >
  #
  #   u.load_field_data
  #   u.gender #=> 'Male'
  #
  #   u.gender = ['Female']
  #   # Writes to Database
  #   u.gender #=> 'Female'
  def load_field_data
    # For each FieldData
    field_data.includes(:field).find_each do |fd|
      # Define a getter, that gets the field_data, called that field's title, on self's singleton
      singleton_class.send(:define_method, self.class.field_to_method_name(fd.field)) do
        fd.deserialized_data
      end

      # Define a setter, that sets the field_data, called that field's title =, on self's singleton
      singleton_class.send(:define_method, "#{self.class.field_to_method_name(fd.field)}=") do |*args|
        fd.data = args[0].to_json
        fd.save!
      end
    end
  end

  # Checks if there any +fields+ that a field user can use, and creates +field_data+
  # for field users were where they do not have +field_data+ for that +field+
  #
  # @author Alex Oxorn
  # @return [void]
  #
  # @overload create_missing_field_data(*ids)
  #   Checks if there any +fields+ that a field user can use from the provided fields, and creates +field_data+
  #   for field users were where they do not have +field_data+ for that +field+
  #   @param *ids [Array<Integer>] ids to check
  #
  #   @example
  #     u = User.new(enterprise_id: 1)
  #     u.skip_some_callbacks = true
  #     u.save
  #
  #     u.field_data #=> []
  #
  #     f = Field.create(field_definer: Enterprise.find(1), title: 'new field')
  #     u.create_missing_field_data(f.id)
  #
  #     u.field_data #=> [< FieldData {new_field => nil} >]
  #
  # @overload create_missing_field_data()
  #   Checks if there any +fields+ that a field user can use from all field_definer's fields, and creates +field_data+
  #   for field users were where they do not have +field_data+ for that +field+
  #
  #   @example
  #     u = User.new(enterprise_id: 1)
  #     u.skip_some_callbacks = true
  #     u.save
  #
  #     u.field_data #=> []
  #
  #     u.create_missing_field_data
  #
  #     u.field_data #=> [< FieldData {gender => nil} >, < FieldData {DOB => nil} >, ... ]
  def create_missing_field_data(*ids)
    from_field_holder = ids.present? ? fields.where(fields: { id: ids }) : fields || []
    from_field_data = field_data.includes(:field).map(&:field)

    missing = from_field_holder - from_field_data
    missing.each do |fld|
      field_data << FieldData.new(field_user: self, field: fld)
    end
  end

  # Creates (but not saves) FieldData
  # for the purposes of creating a Prototype
  #
  # @author Alex Oxorn
  #
  # @return [Array<FieldData>]
  #
  # @example
  #   u = User.new
  #   u.prototype_fields
  #   u.field_data.first => <# FieldData ...>
  def prototype_fields
    from_field_holder = fields || []

    missing = from_field_holder
    field_data = []
    missing.each do |fld|
      field_data << FieldData.new(field: fld)
    end

    field_data
  end

  # Given a field, find the fieldData which
  # holds the data for said field
  #
  # @author Alex Oxorn
  #
  # @param field [Field] field to find data for
  #
  # @return [Array<FieldData>]
  #
  # @example
  #   u = User.first
  #   f = u.fields.first
  #
  #   u.get_field_data(f) => <#FieldData>
  def get_field_data(field)
    field_data.loaded? ?
        field_data.to_a.find { |fd| fd.field == field } :
        field_data.find_by(field: field)
  end

  def get_field_data_value(field)
    get_field_data(field).deserialized_data
  end

  def set_field_data_value(field, data)
    get_field_data(field).update(data: field.serialize_value(data))
  end

  # Class Methods for FieldData Models
  module ClassMethods
    # Evaluates an +ActiveRecord+ query of a +field_user+ and creates getter and setter
    # methods on the singletons of each +field_user+ for its +field_data+
    #
    # @author Alex Oxorn
    #
    # @return [Array<self>]
    #
    # @example
    #   us = User.where('id < 10').load_field_data
    #
    #   us.map(&:gender) #=> ['Male', 'Male', 'Female', ...]
    def load_field_data
      # rubocop:disable Rails/FindEach
      # find each doesn't return the list of objects which I want

      # for each field field_user
      includes(:field_data, field_data: :field).each do |u|
        # for each field_data
        u.field_data.each do |fd|
          # Define a getter, that gets the field_data, called that field's title, on that field_user's singleton
          u.singleton_class.send(:define_method, field_to_method_name(fd.field)) do
            fd.deserialized_data
          end

          # Define a setter, that sets the field_data, called that field's title =, on that field_user's singleton
          u.singleton_class.send(:define_method, "#{field_to_method_name(fd.field)}=") do |*args|
            fd.data = args[0].to_json
            fd.save!
          end
        end
      end
      # rubocop:enable Rails/FindEach
    end

    def field_to_method_name(field)
      field.title.gsub(' ', '_').gsub(/[^0-9a-z_]/i, '').downcase
    end

    # Creates A Prototype
    # And instance of a class with no data, and is not saved int the database
    # the main use case is to serialize and return form the API so that the front end
    # can have a skeleton for which fields to render a form for
    #
    # @author Alex Oxorn
    #
    # @param field_definer [FieldDefiner] the field_definer for this hypothetical object
    #
    # @return [Array<FieldData>]
    #
    # @example
    #   u = User.create_prototype(Enterprise.first)
    #   u.first_name = ""
    #   u.field_data.first.data = ""
    def create_prototype(field_definer)
      new = self.new(field_definer_name.to_sym => field_definer)
      new.field_data = new.prototype_fields
      new
    end
  end
end
