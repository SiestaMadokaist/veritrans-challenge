class Ramadoka::Endpoint::Router
  attr_accessor(:resource, :callback, :errors, :optionals, :requireds, :path, :description, :presenter, :method)
  # @param klass [Class]
  # @param callback [Symbol]
  # @param resource [String]
  def initialize(klass, callback, resource)
    @klass = klass
    @callback = callback
    @resource = resource
    @errors = []
    @optionals = []
    @requireds = []
    @presenter_block = nil
  end

  def meta_copy_to_different_klass(other_klass)
    copy = self.class.new(other_klass, @callback, @resource)
    copy.errors = @errors
    copy.optionals = @optionals
    copy.requireds = @requireds
    copy.path = @path
    copy.description = @description
    copy.presenter = @presenter
    copy.method = @method
    copy
  end

  # @param value [String]
  def path(value)
    @path = value
  end

  # @param value [String]
  def description(value="")
    @description = "(#{@klass}.#{@callback}) - #{value}"
  end

  # @param value [Class]
  def presenter(value, &block)
    @presenter = value
    @presenter_block = block
  end

  # @param error_code [Integer]
  # @param err [Class]
  def error(error_code, err)
    @errors << [error_code, err.to_s, Ramadoka::Entity::Errors]
  end

  # @param value [Symbol]
  # @param value Value: [:post, :get, :delete, :head, :, ...]
  def method(value)
    @method = value
  end

  # @param name [Symbol]
  # @param options :type :optional
  # @param options :default :optional
  def optional(name, options={})
    param = OpenStruct.new
    param.name = name
    param.options = options
    param.required = false
    param.category = :optional
    @optionals << param
  end

  # @param name [Symbol]
  # @param options :type :optional
  # @param options :default :optional
  def required(name, options={})
    param = OpenStruct.new
    param.name = name
    param.options = options
    param.required = true
    param.category = :requires
    @requireds << param
  end

  def params
    @requireds + @optionals
  end

  # @param klass [Class]
  # subclass of Grape::API
  def add_logic_to(klass)
    _description = @description
    _presenter = @presenter
    _errors = @errors
    _params = params
    _method = @method
    _path = @path
    _klass = @klass
    _callback = @callback
    _resource = @resource
    _presenter_block = @presenter_block
    klass.instance_exec do
      resource _resource do
        desc(
          _description,
          entity: _presenter,
          http_codes: _errors
        )
        params do
          _params.each{|p| send(p.category, p.name, p.options) }
        end
        send(_method, _path) do
          req = _klass.new(self)
          result = req.send(_callback)
          _presenter_block.call(_presenter, result, req)
        end
      end
    end
  end
end
