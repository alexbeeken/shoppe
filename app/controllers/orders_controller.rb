class OrdersController < ApplicationController
  before_filter(only: [:paypal, :payment]) { Shoppe::Paypal.setup_paypal }
  def remove_item
    Shoppe::OrderItem.find(params[:id]).remove
    redirect_to basket_path
  end

  def destroy
    Shoppe::Order.find(session[:order_id]).destroy
    redirect_to basket_path
  end

  def confirmation
    if request.post?
      current_order.confirm!
      session[:order_id] = nil
      redirect_to root_path, :success => "Order has been placed successfully!"
    end
  end

  def payment
    @order = Shoppe::Order.find(session[:order_id])
    if params[:success] == "true" && params[:PayerID].present?
      @order.accept_paypal_payment(params[:paymentId], params[:token], params[:PayerID])
      redirect_to checkout_confirmation_path
    else
      redirect_to basket_path, alert: 'Something went wrong with your payment. You have not been charged. Please try again.'
    end
  end

  def paypal
    @order = Shoppe::Order.find(session[:order_id])
    url = @order.redirect_to_paypal(checkout_payment_url(success: true), checkout_payment_url(success: false))
    redirect_to url
  end
end
