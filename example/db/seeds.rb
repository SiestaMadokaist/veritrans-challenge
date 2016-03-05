require File.expand_path("../../application", __FILE__)
Component::PaymentGateway::Domain.instance_exec do
  data = Component::PaymentGateway::Domain.json_data
  data.each do |datum|
    item = from_hash(datum)
    item.save!
  end
end
