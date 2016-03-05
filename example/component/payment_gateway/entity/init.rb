module Component::PaymentGateway::Entity
  class Lite < Grape::Entity
    expose(:id, documentation: {type: "Integer"})
    expose(:name, documentation: {type: "String"})
    expose(:image, documentation: {type: "String (?)"})
    expose(:description, documentation: {type: "String"})
    expose(:rating, documentation: {type: "Float"})
    expose(:currencies, documentation: {type: "String"}) do |item, options|
      item.currencies.pluck(:name).join(" ")
    end
    expose(:setup_fee, documentation: {type: "Integer"})
    expose(:transaction_fees, documentation: {type: "String"})
    expose(:how_to_url, documentation: {type: "String", desc: "how to use tutorial"})
  end
end
