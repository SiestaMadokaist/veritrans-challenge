class Component::Currency < ActiveRecord::Base

  class << self

    # @param find_attr [Symbol]
    # @param options [Hash]
    def find_or_create!(find_attr, options)
      item = send("find_by_#{find_attr}".to_sym, options[find_attr])
      return item unless item.nil?
      create(options)
    end

  end

  has_and_belongs_to_many(:payment_gateways)

  extend Memoist

  def domain
    self.class::Domain.new(self)
  end
  memoize(:domain)

end
