class CreateShippingAddresses < ActiveRecord::Migration
  def self.up
    create_table :shipping_addresses do |t|
      t.string  :company,        null: false, default: ""
      t.string  :street,         null: false, default: ""
      t.string :postcode,       null: false, default: ""
      t.string  :suburb,         null: false, default: ""
      t.string  :state,          null: false, default: ""
      t.string  :country,        null: false, default: ""
      t.string :phone,          null: false, default: ""
      t.string  :type,           null: false, default: ""
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :shipping_addresses
  end
end
