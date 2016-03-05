class Ramadoka::Endpoint::Base

  @routes = {}
  @mounted_class = Class.new(Grape::API)
  @resource = "base"

  extend Memoist

  def self.get_route(path)
    if(self == Ramadoka::Endpoint::Base)
      @routes[path] || @routes["404"]
    else
      if(not @routes[path].nil?)
        @routes[path]
      else
        superclass.get_route(path)
      end
    end
  end

  def self.initialize_route!
    @routes = {}
  end

  def self.initialize_mounted_class!
    @mounted_class = Class.new(Grape::API)
    @mounted_class.instance_exec do
      format :json
    end
  end

  def self.routes
    @routes
  end

  def route_not_found
  end

  # @param methodname: [Symbol]
  # @param resource: [String]
  def self.route!(methodname, resource, &logic)
    raise ErrInvalidMethodName, "methodname must start with 'route'" unless methodname.to_s.match(/^route/)
    router = Ramadoka::Endpoint::Router.new(self, methodname, resource)
    router.instance_exec(&logic)
    router.add_logic_to(@mounted_class)
    @routes[methodname] = router
  end

  def self.copy_parent_logic!
    @routes.each do |methodname, prouter|
      my_router = prouter.meta_copy_to_different_klass(self)
      my_router.add_logic_to(@mounted_class)
    end
  end

  def self.inherited(subklass)
    subklass.initialize_route!
    subklass.initialize_mounted_class!
    @routes.each{|k, v| subklass.routes[k] = v if subklass.routes[k].nil? }
    subklass.copy_parent_logic!
  end

  def self.mounted_class
    @mounted_class
  end

  def initialize(request)
    @request = request
  end

  def params
    @request.params
  end

  def page
    params[:page]
  end

  def per_page
    params[:per_page]
  end

end
