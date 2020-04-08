class ReactRoutesHelper
  ROUTES_JSON = File.read('./app/helpers/routes.json')

  def self.routes_hash
    @routes ||= JSON.parse(ROUTES_JSON)
  end

  def self.make_class(routes)
    klass = Class.new
    klass.define_singleton_method(:routes_hash) do
      routes
    end

    klass.define_singleton_method(:make_class) do |new_routes|
      ReactRoutesHelper.make_class new_routes
    end

    klass.class_eval do
      routes_hash.keys.each do |key|
        case routes_hash[key]
        when Hash
          define_singleton_method key do
            make_class routes_hash[key]
          end
        when String
          parts = routes_hash[key].split('/')
          define_singleton_method key do |*args|
            copied_args = args
            mapped_parts = parts.map do |part|
              if part.start_with? ':'
                arg = copied_args.shift
                case arg
                when -> (a) {a.respond_to?(:id)} then arg.id
                when Integer, String then arg.to_s
                else part
                end
              else
                part
              end
            end
            mapped_parts.join('/')
          end
        else
        end
      end
    end

    klass
  end

  def self.routes
    @routes_class ||= make_class routes_hash
  end
end
