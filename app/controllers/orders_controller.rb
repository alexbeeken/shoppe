class OrdersController < ApplicationController
  before_filter(only: [:paypal, :payment]) { Shoppe::Paypal.setup_paypal }

  def checkout
    @order = Shoppe::Order.find(current_order.id)
  end

  def add
    @product = Shoppe::Product.root.find_by_permalink!(params[:permalink])
    current_order.order_items.add_item(@product, 1)
  end

  def checkout
    @order = Shoppe::Order.find(current_order.id)
    if request.patch?
      if @order.proceed_to_confirm(params[:order].permit(:first_name, :last_name, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_country_id, :billing_postcode, :email_address, :phone_number))
        redirect_to checkout_payment_path
      end
    end
  end

  def destroy
    @order = Shoppe::Order.find(current_order.id).destroy
    redirect_to basket_path
  end

  def confirmation
    if request.post?
      current_order.confirm!
      session[:order_id] = nil
      redirect_to root_path, :notice => "Order has been placed successfully!"
    end
  end

  def payment
    if params[:success] == "true" && params[:PayerID].present?
      @order.accept_paypal_payment(params[:paymentId], params[:token], params[:PayerID])
    end
    if request.post?
      redirect_to checkout_confirmation_path
    end
  end

  def paypal
    @order = Shoppe::Order.find(session[:current_order_id])
    url = @order.redirect_to_paypal(checkout_payment_url(success: true), checkout_payment_url(success: false))
    redirect_to url
  end
end
