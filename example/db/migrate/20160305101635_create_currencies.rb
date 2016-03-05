class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table(:currencies) do |t|
      t.datetime(:created_at, null: false)
      t.datetime(:updated_at, null: false)
      t.string(:name, null: false)
      t.float(:rate, null: false)
    end
  end

  def self.down
    drop_table(:currencies)
  end
end
