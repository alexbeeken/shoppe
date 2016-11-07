class MakeBillingAddressesNullable < ActiveRecord::Migration
  def change
    change_column :shoppe_orders, :billing_address2, :string, default: nil, null: true
    change_column :shoppe_orders, :billing_address3, :string, default: nil, null: true
    change_column :shoppe_orders, :billing_address4, :string, default: nil, null: true
  end
end
