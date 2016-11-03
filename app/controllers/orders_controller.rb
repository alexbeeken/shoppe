class OrdersController < ApplicationController
  before_filter(only: [:paypal, :payment]) { Shoppe::Paypal.setup_paypal }
  def remove_item
    Shoppe::OrderItem.find(params[:id]).remove
    redirect_to basket_path
  end

  def destroy
    Shoppe::Order.find(current_order.id).destroy
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
    @order = Shoppe::Order.find(current_order.id)
    if params[:success] == "true" && params[:PayerID].present?
      @order.accept_paypal_payment(params[:paymentId], params[:token], params[:PayerID])
      reset_basket
      render :thank_you
    end
    if request.post?
      redirect_to checkout_confirmation_path
    end
  end

  def paypal
    @order = Shoppe::Order.find(session[:order_id])
    url = @order.redirect_to_paypal(checkout_payment_url(success: true), checkout_payment_url(success: false))
    redirect_to url
  end
end
