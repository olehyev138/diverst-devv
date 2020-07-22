class ReactRoutes
  ROUTES_JSON = File.read('./app/assets/json/routes.json')

  def self.routes_hash
    @routes ||= JSON.parse(ROUTES_JSON)
  end

  def self.domain
    #
    ## TEMP: `beta` is a temporary prefix
    #
    ENV['ENV_NAME'] ? "https://beta-#{ENV['ENV_NAME']}.diverst.com" : 'http://localhost:8082'
  end

  def self.make_class(routes)
    klass = Class.new
    klass.define_singleton_method(:routes_hash) do
      routes
    end

    klass.define_singleton_method(:make_class) do |new_routes|
      ReactRoutes.make_class new_routes
    end

    klass.class_eval do
      routes_hash.keys.each do |key|
        case routes_hash[key]
        when Hash
          define_singleton_method key do
            instance_variable_get("@#{key}_class") || instance_variable_set("@#{key}_class", make_class(routes_hash[key]))
          end
        when String
          parts = routes_hash[key].split('/')
          define_singleton_method key do |*args|
            copied_args = args
            mapped_parts = parts.map do |part|
              if part.start_with? ':'
                arg = copied_args.shift
                case arg
                when -> (a) { a.respond_to?(:id) } then arg.id
                when Integer, String then arg.to_s
                else part
                end
              else
                part
              end
            end
            ReactRoutes.domain + mapped_parts.join('/')
          end
        end
      end
    end

    klass.define_singleton_method(:inspect) do
      parts = routes_hash.keys.map do |n|
        if String === routes_hash[n]
          "#{n} => #{send(n)}"
        else
          n
        end
      end.join(",\n\t")

      "#{super()} (\n\t#{parts}\n)"
    end

    klass
  end

  class << self
    def routes
      @routes_class ||= make_class routes_hash
    end

    delegate :inspect, :user, :group, :session, :anonymous, :admin, to: :routes

    # catch other base routes that have not been explicitly defined above
    def method_missing(method, *args, &block)
      return super method, *args, &block unless routes.respond_to?(method)

      routes.send(method, *args)
    end

    def respond_to_missing?(method_name, *args)
      routes.respond_to?(method_name)
    end
  end
end
