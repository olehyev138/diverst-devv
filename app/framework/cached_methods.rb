module CachedMethods

  def self.included(klass)
    klass.extend ClassMethods
  end

  def key(name, *args)
    "#{self.model_name.name}::#{id}::#{name}::#{args}"
  end

  module ClassMethods
    def cache(*method_names)
      method_names.each do |m|
        proxy = Module.new do
          define_method(m) do |*args|
            Rails.cache.fetch(key(m, args)) do
              super *args
            end
          end

          define_method("#{m}!") do |*args|
            Rails.cache.fetch(key(m, args), force: true) do
              method(m).super_method.call(*args)
            end
          end

          define_method("#{m}_") do |*args|
            Rails.cache.delete(key(m, args))
          end
        end
        self.prepend proxy
      end
    end
  end
end
