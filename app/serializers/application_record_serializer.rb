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
    attr_writer :_instance_reflections, :_instance_attributes_data

    def _instance_reflections
      @_instance_reflections ||= {}
    end

    def _instance_attributes_data
      @_instance_attributes_data ||= {}
    end

    def initialize(object, options = {})
      self.object = object
      self.instance_options = options
      self.root = instance_options[:root]
      self.scope = instance_options[:scope]

      return if !(scope_name = instance_options[:scope_name]) || respond_to?(scope_name)

      define_singleton_method scope_name, -> { scope }
    end

    # @example
    #   class AdminAuthorSerializer < ActiveModel::Serializer
    #     attributes :id, :name, :recent_edits
    def instance_attributes(*attrs)
      attrs = attrs.first if attrs.first.class == Array

      attrs.each do |attr|
        instance_attribute(attr)
      end
    end

    # @example
    #   class AdminAuthorSerializer < ActiveModel::Serializer
    #     attributes :id, :recent_edits
    #     attribute :name, key: :title
    #
    #     attribute :full_name do
    #       "#{object.first_name} #{object.last_name}"
    #     end
    #
    #     def recent_edits
    #       object.edits.last(5)
    #     end
    def instance_attribute(attr, options = {}, &block)
      key = options.fetch(:key, attr)
      self._instance_attributes_data[key] = Attribute.new(attr, options, block)
    end

    # @param [Symbol] name of the association
    # @param [Hash<Symbol => any>] options for the reflection
    # @return [void]
    #
    # @example
    #  has_many :comments, serializer: CommentSummarySerializer
    #
    def instance_has_many(name, options = {}, &block) # rubocop:disable Style/PredicateName
      instance_associate(HasManyReflection.new(name, options, block))
    end

    # @param [Symbol] name of the association
    # @param [Hash<Symbol => any>] options for the reflection
    # @return [void]
    #
    # @example
    #  belongs_to :author, serializer: AuthorSerializer
    #
    def instance_belongs_to(name, options = {}, &block)
      instance_associate(BelongsToReflection.new(name, options, block))
    end

    # @param [Symbol] name of the association
    # @param [Hash<Symbol => any>] options for the reflection
    # @return [void]
    #
    # @example
    #  has_one :author, serializer: AuthorSerializer
    #
    def instance_has_one(name, options = {}, &block) # rubocop:disable Style/PredicateName
      instance_associate(HasOneReflection.new(name, options, block))
    end

    # Add reflection and define {name} accessor.
    # @param [ActiveModel::Serializer::Reflection] reflection
    # @return [void]
    #
    # @api private
    private def instance_associate(reflection)
      key = reflection.options[:key] || reflection.name
      self._instance_reflections[key] = reflection
    end

    private def merged_attr_data
      self._instance_attributes_data.merge(self.class._attributes_data)
    end

    private def merged_reflections
      self._instance_reflections.merge(self.class._reflections)
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
    unless self.class == ApplicationRecordSerializer
      if serialize_all_fields
        self.instance_attributes(object.attributes.keys.map(&:to_sym).reject { |attr| excluded_keys.map(&:to_sym).include?(attr) })
      end
    end

    super(object, options)
  end

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
            Pundit::PolicyFinder.new(object).policy&.new(
                scope&.dig(:current_user) || (Rails.env.development? && @@test_user ||= User.first),
                object,
                scope&.dig(:params) || @instance_options[:params] || {}
              )
  )
  end

  def policies
    [:show?, :update?, :destroy?]
  end

  def permissions
    policies.reduce({}) { |sum, m| sum[m] = (policy.send(m)); sum }
  end
end
