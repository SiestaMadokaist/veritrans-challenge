class Component::PaymentGateway::Domain

  class << self

    # @param raw_currencies [String]
    def parse_currencies(raw_currencies)
      raw_currencies
        .split(",")
        .map(&:strip)
        .map{|curr| Component::Currency.find_or_create!(:name, name: curr, rate: 1) }
    end

    # @param hash [Hashie::Mash]
    def from_hash(hash)
      currencies = Maybe
        .from_value(hash[:currencies])
        .map{|currs| parse_currencies(currs)}
        .value([])

      type_correction = {
        branding: hash[:branding] == "1",
        rating: hash[:rating].to_f,
        setup_fee: hash[:setup_fee].to_i,
        currencies: currencies
      }
      kwargs = hash.merge(type_correction)
      parent.new(kwargs)
    end

    def json_data
      open(parent::JsonDataPath) do |f|
        Hashie::Mash[JSON.parse(f.read)][:payment_gateways]
      end
    end

    def fuzzy_search(query)
      item_ids = parent.select([:id, :name]).select{|x| x.domain.fuzzy_match?(query)}.map(&:id)
      parent.where(id: item_ids)
    end

  end

  # @param payment_gateway [Component::PaymentGateway]
  def initialize(payment_gateway)
    @item = payment_gateway
  end

  def fuzzy_match?(query)
    return true if query.nil?
    queryIndex = query.length - 1
    return true if queryIndex < 0
    queryChar = query[queryIndex]
    compared = @item.name.downcase
    (0..compared.length - 1).reverse_each do |i|
      if(queryChar == compared[i])
        return true if (queryIndex == 0)
        queryIndex -= 1
        queryChar = query[queryIndex]
      end
    end
    return false
  end

end
