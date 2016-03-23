class Component::PaymentGateway::Endpoint::V2 < Component::PaymentGateway::Endpoint::V1
  def route
    o = OpenStruct.new
    o.data = 2
    [o, o, o]
  end
  route!(:route, "videos") do
    path "/override"
    method :get
    description "overridding v1"
    presenter Component::PaymentGateway::Entity::Lite
    success{|_, result, _| result}
    failure{|_, err, _| err}
    optional :page, type: Integer, default: 1
    optional :per_page, type: Integer, default: 1
  end

  inherit!
end

class Component::PaymentGateway::Endpoint::V3 < Component::PaymentGateway::Endpoint::V2
  inherit!
end
