class MrbeekenPaypal
  include PayPal::SDK::REST

  def self.process_shipping_info(order, pay_id)
    payer_info = Payment.find(pay_id).payer.payer_info
    shipping_address = payer_info.shipping_address
    order.update!(
      delivery_address1: shipping_address.line1,
      delivery_address2: shipping_address.line2 || " ",
      delivery_country_id: shipping_address.country_code,
      delivery_name: shipping_address.recipient_name,
      delivery_name: shipping_address.recipient_name,
      delivery_postcode: shipping_address.postal_code,
      email_address: payer_info.email,
      first_name: payer_info.first_name,
      last_name: payer_info.last_name,
      billing_address1: 'N/A',
      billing_address2: 'N/A',
      billing_address3: 'N/A',
      billing_address4: 'N/A',
      billing_postcode: 'N/A',
      billing_country: Shoppe::Country.last,
      phone_number: '555-555-5555'
    )
  end
end
