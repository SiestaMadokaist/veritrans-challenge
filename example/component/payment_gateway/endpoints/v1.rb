module Component::PaymentGateway::Endpoint; end
class Component::PaymentGateway::Endpoint::V1 < Ramadoka::Endpoint::Base

  class << self
    def paginated_response
      proc do |presenter, result, req|
        Common::Primitive::Entity.show(data: result, presenter: presenter, pagination: {page: req.page, per_page: req.per_page})
      end
    end

    def normal_response
      proc do |presenter, result, _|
        Common::Primitive::Entity.show(data: result, presenter: presenter)
      end
    end

    def failure_response
      proc do |_, err, known_errors, _|
        error_pack  = known_errors
          .select{|c, m, p| m == err.class.name}
          .first
        if(error_pack.nil?)
          presenter = ERR::Presenter
        else
          code, _, presenter = error_pack
        end
        Common::Primitive::Entity.show(data: [err], code: code, error: true, presenter: presenter)
      end
    end
  end

  presenter(Component::PaymentGateway::Entity::Lite)
  error_presenter(ERR::Presenter)

  resource("/payment_gate")

  success(&paginated_response)
  failure(&failure_response)

  base_error(ActiveRecord::RecordNotFound, 404)
  base_error(ERR::NotFound404)

  # fuzzy_match?("itv", "tvi") => false
  # fuzzy_match?("itv, "iiiittttttvvvv"") => true
  # fuzzy_match?("itv", "itititititiv") => true
  def route_fuzzy_search
    errs = [ZeroDivisionError, ActiveRecord::RecordNotFound, ERR::NotFound404]
    raise errs.shuffle.first
    query = params[:query]
    result = Component::PaymentGateway::Domain
      .fuzzy_search(query)
      .includes(:currencies)
      .rate_wise
  end
  route!(:route_fuzzy_search) do
    path("/fuzzy_search")
    method(:get)
    optional(:query, type: String, default: "", desc: "fuzzy searching query, e.g: (moduser, models/users) == true")
    optional(:page, type: Integer, default: 1)
    optional(:per_page, type: Integer, default: 3)
    description("list all payment gateway whose name fuzzily matching the  query")
  end

  def route_index
    query = params[:query]
    Component::PaymentGateway.where("name like ?", "%#{query}%")
      .includes(:currencies)
      .rate_wise
  end

  route!(:route_index) do
    path("/search")
    method(:get)
    required(:query, type: String, default: "", desc: "where name like %query%")
    optional(:page, type: Integer, default: 1)
    optional(:per_page, type: Integer, default: 3)
    description("list all payment whose name like the query")
  end

  def route_all
    Component::PaymentGateway.rate_wise
  end
  route!(:route_all) do
    path("/list")
    method(:get)
    description("all available payment gateway")
    optional(:page, type: Integer, default: 1)
    optional(:per_page, type: Integer, default: 3)
    error(ERR::NoAuthorization401)
  end

  def route_count
    Component::PaymentGateway.count
  end
  route!(:route_count, "/pg") do
    path("/count")
    method(:get)
    description("amount of payment gateway record")
    presenter(nil)
    success{|_, result, _| result}
    failure{|_, err, _| err}
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
  route!(:route_by_currency) do
    path("/search/currency/:currency")
    method(:get)
    optional(:page, type: Integer, default: 1)
    optional(:per_page, type: Integer, default: 3)
    description("listing payment gateway available with a certain currency")
  end

end
