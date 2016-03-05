class CurrenciesPaymentGateways < ActiveRecord::Migration
  def self.up
    create_table(:currencies_payment_gateways) do |t|
      t.datetime(:created_at)
      t.datetime(:updated_at)
      t.integer(:currency_id, null: false)
      t.integer(:payment_gateway_id, null: false)
    end
  end

  def self.down
    drop_table(:currencies_payment_gateways)
  end
end
