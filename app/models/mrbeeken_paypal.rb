class MrbeekenPaypal
  include PayPal::SDK::REST

  def self.process_shipping_info(order, pay_id)
    payer_info = Payment.find(pay_id).payer.payer_info
    shipping_address = payer_info.shipping_address
    order.update!(
      email: payer_info.email,
      first_name: payer_info.first_name,
      last_name: payer_info.last_name,
      error: payer_info.error,
      delivery_address1: shipping_address.line1,
      delivery_address2: shipping_address.line2 || " ",
      delivery_address3: shipping_address.line3 || " ",
      delivery_address4: shipping_address.line4 || " ",
      delivery_postcode: shipping_address.postal_code,
      delivery_country_id: shipping_address.country_code,
      delivery_name: shipping_address.recipient_name,
      delivery_name: shipping_address.recipient_name,
    )
  end
end
