# Implementing a serializer:
#   Strategies:
#     - Blacklist:
#         The quickest method of implementing a serializer.
#
#         Simply creating the serializer class with no content will serialize nothing
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

  def self.inherited(subclass)
    super
    class << subclass
      def permission_module
        @module ||= begin
                       temp = Module.new do
                         def self.attr_conditions
                           @attr_conditions ||= Hash.new { |hash, key| hash[key] = [] }
                         end
                       end
                       prepend(temp)
                       temp
                     end
      end

      def attributes_with_permission(*attribute_names, **options)
        raise RuntimeError.new('No Attributes') if attribute_names.blank?

        attribute_names.each do |attr|
          attributes attr unless _attributes.include? attr
          ifs = permission_module.attr_conditions[attr] << options[:if]

          unless permission_module.instance_methods(false).include? attr
            permission_module.define_method(attr) do
              if self.class.permission_module.attr_conditions[__method__].any? { |pred| send(pred) }
                if defined?(super)
                  super()
                else
                  object&.send(attr)
                end
              else
                nil
              end
            end
          end
        end
      end
    end
  end

  # If the serialier hasn't specifically set any attributes to use (or enables serialization of all fields)
  # it will use all model attributes, excluding any fields listed in an implementation of the `excluded_keys` method.
  def initialize(object, options = {})
    unless self.class == ApplicationRecordSerializer
      if serialize_all_fields
        self.class.attributes(object.attributes.keys.map(&:to_sym).reject { |attr| excluded_keys.map(&:to_sym).include?(attr) })
      end
    end

    super(object, options)
    raise SerializerScopeNotDefinedException if @scope.nil? && Rails.env.test?
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

  # Finds the policy for a particular object
  # If a policy is provided, use that
  # Otherwise, find the policy based on the object being serialized
  #
  # If a policy can't be found, or if current user isn't defined in the scope
  # then instead return a pseudo policy which will return false on any method call
  def policy
    @policy ||= begin
                  if @instance_options[:policy].present?
                    # Use provided Policy
                    @instance_options[:policy]
                  else
                    # Find and instantiate Policy based on the serialized object
                    Pundit::PolicyFinder.new(object).policy.new(
                        scope&.dig(:current_user),
                        object,
                        scope&.dig(:params) || @instance_options[:params] || {}
                    )
                  end
                rescue Pundit::NotAuthorizedError, NoMethodError
                  # If the user isn't defined, return the pseudo policy
                  Class.new do
                    def method_missing(m, *args, &block)
                      false
                    end
                  end.new
                end
  end

  def policies
    [:show?, :update?, :destroy?]
  end

  def permissions
    policies.reduce({}) { |sum, m| sum[m] = (policy.send(m)); sum }
  end
end
