class CreatePaymentGateways < ActiveRecord::Migration
  def self.up
    create_table(:payment_gateways) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.string(:name, null: false)
      t.text(:image)
      t.string(:description)
      t.boolean(:branding, null: false, default: false)
      t.float(:rating, null: false, default: 0)
      t.boolean(:setup_fee, null: false, default: false)
      t.string(:transaction_fees)
      t.string(:how_to_url)
    end
  end

  def self.down
    drop_table(:payment_gateways)
  end
end
