require "hashie"
class Component::PaymentGateway < ActiveRecord::Base
  extend Memoist
  JsonDataPath = File.expand_path("../data.json", __FILE__)

  scope(:rate_wise, ->(){
    order("`rating` DESC")
  })

  attr_accessible(
    :id,
    :name,
    :image,
    :description,
    :branding,
    :rating,
    :currencies,
    :setup_fee,
    :transaction_fees,
    :how_to_url,
  )
  has_and_belongs_to_many(:currencies, class_name: "Component::Currency")

  def domain
    self.class::Domain.new(self)
  end
  memoize(:domain)

end
