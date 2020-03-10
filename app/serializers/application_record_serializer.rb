# Implementing a serializer:
#   Strategies:
#     - Blacklist:
#         The quickest method of implementing a serializer.
#
#         Simply creating the serializer class with no content will default to serializing all the fields of a model.
#
#         Define an `excluded_keys` method in your class that returns an array of symbols representing the keys
#         of the fields you want to exclude. Ex: `[:enterprise_id]`
#
#         * Note *: If you need to call `attributes`, say in order to add custom fields to a serialization, but
#                   still want to use a blacklist for the rest of the fields, define the `serialize_all_fields`
#                   method and return `true`.
#
#     - Whitelist:
#         Create a serializer class that contains a call to define only which attributes will be serialized. Ex:
#             class SomethingSerializer < ApplicationRecordSerializer
#               attributes :id, :name
#             end
#
class ApplicationRecordSerializer < ActiveModel::Serializer
  include BaseSerializer

  ActiveModel::Serializer.class_eval do
    def merged_attr_data
      self.singleton_class._attributes_data.merge(self.class._attributes_data)
    end

    def merged_reflections
      self.singleton_class._reflections.merge(self.class._reflections)
    end

    def attributes(requested_attrs = nil, reload = false)
      @attributes = nil if reload
      @attributes ||= merged_attr_data.each_with_object({}) do |(key, attr), hash|
        next if attr.excluded?(self)
        next unless requested_attrs.nil? || requested_attrs.include?(key)

        hash[key] = attr.value(self)
      end
    end

    def associations(include_directive = ActiveModelSerializers.default_include_directive, include_slice = nil)
      include_slice ||= include_directive
      return Enumerator.new { } unless object

      Enumerator.new do |y|
        (self.instance_reflections ||= merged_reflections.deep_dup).each do |key, reflection|
          next if reflection.excluded?(self)
          next unless include_directive.key?(key)

          association = reflection.build_association(self, instance_options, include_slice)
          y.yield association
        end
      end
    end
  end

  # If the serialier hasn't specifically set any attributes to use (or enables serialization of all fields)
  # it will use all model attributes, excluding any fields listed in an implementation of the `excluded_keys` method.
  def initialize(object, options = {})
    singleton_class._attributes_data = {} if singleton_class._attributes_data.object_id == self.class._attributes_data.object_id
    singleton_class._reflections = {} if singleton_class._reflections.object_id == self.class._reflections.object_id

    unless self.class == ApplicationRecordSerializer
      if serialize_all_fields
        self.singleton_class.attributes(object.attributes.keys.map(&:to_sym).reject { |attr| excluded_keys.map(&:to_sym).include?(attr) })
      end
    end

    super(object, options)
  end

  delegate :attributes, to: :singleton_class, prefix: 'serializer'
  delegate :has_many, to: :singleton_class
  delegate :has_one, to: :singleton_class

  # On serialization, excludes any keys that are returned by the `excluded_keys` method from the result
  def attributes(requested_attrs = nil, reload = false)
    super(requested_attrs, reload).except(*excluded_keys.map(&:to_sym))
  end

  # If this method returns true in a subclass, the `attributes` call of that subclass will NOT define specifically
  # which attributes to return, instead it will simply add to the attributes being returned.
  def serialize_all_fields
    false
  end

  def policy
    @policy ||= (
    @instance_options[:policy] ||
            Pundit::PolicyFinder.new(object).policy&.new(scope&.dig(:current_user), object, @instance_options[:params])
  )
  end

  def policies
    [:show?, :update?, :delete?]
  end

  def permissions
    policies.reduce({}) { |sum, m| sum[m] = (policy.send(m) rescue nil); sum }
  end
end
