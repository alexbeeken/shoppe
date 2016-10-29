class ProductsController < ApplicationController
  def index
    @products = Shoppe::Product.root.ordered.includes(:product_categories, :variants)
  end

  def show
    @product = Shoppe::Product.root.find_by_permalink(params[:permalink])
  end

  def buy
    begin
      @product = Shoppe::Product.root.find_by_permalink!(params[:permalink])
      @quantity = params['quantity'] || 1
      current_order.order_items.add_item(@product, @quantity.to_i)
      flash[:success] = "#{@quantity} x #{@product.name} has been added to basket!"
      redirect_to product_path(@product.permalink)
    rescue Shoppe::Errors::NotEnoughStock => e
      flash[:alert] = "Sorry, #{@product.name} is sold out or not available in that quantity."
      redirect_to product_path(@product.permalink)
    rescue Shoppe::Errors::UnorderableItem => e
      flash[:alert] = "Sorry, an error has occured. Please contact musiccramsessions@gmail.com for help."
      redirect_to product_path(@product.permalink)
    end
  end
end
