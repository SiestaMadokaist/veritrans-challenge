module Component::PaymentGateway::Endpoint; end
class Component::PaymentGateway::Endpoint::V1 < Ramadoka::Endpoint::Base
  def route_v1
    o = OpenStruct.new
    o.data =  1
    [o, o, o]
  end

  # fuzzy_match?("itv", "tvi") => false
  # fuzzy_match?("itv, "iiiittttttvvvv"") => true
  # fuzzy_match?("itv", "itititititiv") => true
  def route_fuzzy_search
    query = params[:query]
    result = Component::PaymentGateway::Domain
      .fuzzy_search(query)
      .includes(:currencies)
      .rate_wise
  end
  route!(:route_fuzzy_search, "payment_gateways") do
    path("/fuzzy_search")
    method(:get)
    optional(:query, type: String, default: "", desc: "fuzzy searching query, e.g: (moduser, models/users) == true")
    optional(:page, type: Integer, default: 1)
    optional(:per_page, type: Integer, default: 3)
    description("list all payment gateway whose name fuzzily matching the  query")
    presenter(Component::PaymentGateway::Entity::Lite) do |presenter, result, req|
      Common::Primitive::Entity.show(data: result, presenter: presenter, pagination: {page: req.page, per_page: req.per_page})
    end
  end

  def route_index
    query = params[:query]
    Component::PaymentGateway.where("name like ?", "%#{query}%")
      .includes(:currencies)
      .rate_wise
  end
  route!(:route_index, "payment_gateways") do
    path("/search")
    method(:get)
    required(:query, type: String, default: "", desc: "where name like %query%")
    optional(:page, type: Integer, default: 1)
    optional(:per_page, type: Integer, default: 3)
    description("list all payment whose name like the query")
    presenter(Component::PaymentGateway::Entity::Lite) do |presenter, result, req|
      Common::Primitive::Entity.show(data: result, presenter: presenter, pagination: {page: req.page, per_page: req.per_page})
    end
  end

  def route_all
    Component::PaymentGateway.rate_wise
  end
  route!(:route_all, "payment_gateways") do
    path("/list")
    method(:get)
    description("all available payment gateway")
    optional(:page, type: Integer, default: 1)
    optional(:per_page, type: Integer, default: 3)
    presenter(Component::PaymentGateway::Entity::Lite) do |presenter, result, req|
      Common::Primitive::Entity.show(data: result, presenter: presenter, pagination: {page: req.page, per_page: req.per_page})
    end
  end

  def route_count
    Component::PaymentGateway.count
  end
  route!(:route_count, "payment_gateways") do
    path("/count")
    method(:get)
    description("amount of payment gateway record")
    presenter(nil){|_, result, _| result}
  end

  def route_by_currency
    currency = params[:currency]
    Maybe
      .from_value(Component::Currency.find_by_name(currency))
      .map(&:payment_gateways)
      .map{|data| data.includes(:currencies)}
      .map(&:rate_wise)
      .value([])
  end
  route!(:route_by_currency, "payment_gateways") do
    path("/search/currency/:currency")
    method(:get)
    optional(:page, type: Integer, default: 1)
    optional(:per_page, type: Integer, default: 3)
    description("listing payment gateway available with a certain currency")
    presenter(Component::PaymentGateway::Entity::Lite) do |presenter, result, req|
      Common::Primitive::Entity.show(data: result, presenter: presenter, pagination: {page: req.page, per_page: req.per_page})
    end
  end


end
