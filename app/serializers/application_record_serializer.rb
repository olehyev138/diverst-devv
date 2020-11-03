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

    subclass.const_set('Tester', Class.new do
      attr_reader :serializer, :user, :action, :klass, :object

      def initialize(object, user: nil, action:, options: {}, path: ['object'], failures: [])
        @klass = object.class
        @path = path
        @head = path.size == 1
        @object = @head ? @klass.preload_all(action: action, user: user).find(object.id) : object
        @user = user
        @action = action
        @options = options
        @failures = failures
        @serializer = self.class.parent.new(
            @object,
            options.merge({ scope: { current_user: user, action: action } })
          )
      end

      def parent
        @@parent = self.class.parent
      end

      def attributes
        @attributes ||= parent._attributes.map do |attr|
          [attr, (object.association(attr) rescue nil)]
        end.filter(&:second).filter { |attr| serializer.validate(attr.first) }
      end

      def reflections
        @reflections ||= parent._reflections.map do |attr, ref|
          [attr, (object.association(attr) rescue nil)]
        end.filter(&:second)
      end

      def associations
        @associations ||= (attributes + reflections).to_h
      end

      def preloaded?
        attributes.each do |attr, assoc|
          loaded?(attr, assoc)
          recursive?(attr, assoc) if parent.instance_methods(false).include? attr
        end
        reflections.each do |attr, assoc|
          loaded?(attr, assoc)
          recursive?(attr, assoc)
        end
        if @head && @failures.present?
          raise StandardError, "#{@failures.join('; ')} #{@failures.size == 1 ? 'is' : 'are'} not preloaded"
        end

        true
      end

      def loaded?(attr, assoc)
        @failures.append([*@path, attr].join('.')) unless assoc.loaded?
      end

      def recursive?(attr, assoc)
        serializer = @options[:use_serializer]

        sub_object = case assoc
                     when ActiveRecord::Associations::CollectionAssociation
                       object.send(attr).first
                     when ActiveRecord::Associations::SingularAssociation
                       object.send(attr)
                     else nil
        end

        serializer ||= ActiveModel::Serializer.serializer_for(sub_object)

        return true unless sub_object

        serializer::Tester.new(
            sub_object,
            user: user,
            action: action,
            options: @options,
            path: [*@path, "#{attr}[]"],
            failures: @failures
          ).preloaded?
      end
    end)

    class << subclass
      def permission_module
        @module ||= begin
                       temp = Module.new do
                         class << self
                           def attr_conditions
                             @attr_conditions ||= Hash.new do |hash, key|
                               hash[key] = []
                             end
                           end

                           delegate :[], :key?, :inspect, to: :attr_conditions
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
              if validate(__method__)
                if defined?(super)
                  begin
                    super()
                  rescue NoMethodError
                    nil
                  end
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
    if @scope.nil?
      def self.scope
        scope = Object.new
        def scope.method_missing(*args)
          if Rails.env.production?
            Rollbar.error(SerializerScopeNotDefinedException.new)
            nil
          else
            Clipboard.copy caller_locations
            raise SerializerScopeNotDefinedException
          end
        end

        def scope.blank?
          true
        end
        scope
      end
    end
  end

  def validate(field)
    !self.class.permission_module.key?(field) || self.class.permission_module[field].any? { |pred| send(pred) }
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
                  # User provided policy, or find and instantiate a new policy based on the serialized object
                  @instance_options[:policy].presence || Pundit::PolicyFinder.new(object).policy.new(
                        scope&.dig(:current_user),
                        object,
                        scope&.dig(:params) || @instance_options[:params] || {}
                      )
                rescue Pundit::NotAuthorizedError, NoMethodError
                  # If the user isn't defined, or the policy not found, return the pseudo policy
                  Class.new do
                    def method_missing(m, *args, &block)
                      false
                    end
                  end.new
                end
  end

  def new_action_instance_options(new_action)
    new = instance_options.dup
    new[:scope][:action] = new_action
    new
  end

  def policies
    [:show?, :update?, :destroy?]
  end

  def permissions
    policies.reduce({}) { |sum, m| sum[m] = (policy.send(m)); sum }
  end

  def show_action?
    ['show', 'prototype'].include?(scope[:action])
  end

  def commit_action?
    ['create', 'update'].include?(scope[:action])
  end

  private def method_missing(symbol, *args)
    case symbol.to_s
    when /([a-zA-Z_]+)_action\?/
      scope[:action] == $1
    else
      super
    end
  end
end
