class ProductsController < ApplicationController
  def index
    @store_active = true
    @products = Shoppe::Product.root.ordered.includes(:product_categories, :variants)
  end

  def show
    @product = Shoppe::Product.root.find_by_permalink(params[:permalink])
  end

  def buy
    handle_errors do
      @product = if params[:variant]
                   Shoppe::Product.find(params[:variant].to_i)
                 else
                   Shoppe::Product.root.find_by_permalink!(params[:permalink])
                 end
      @quantity = params['quantity'].to_i
      raise Shoppe::Errors::NotEnoughStock unless quantity_valid?(@product, @quantity)
      current_order.order_items.add_item(@product, @quantity)
      flash[:success] = "#{@quantity} x #{@product.name} has been added to basket!"
      redirect_to '/store'
    end
  end

  def variant
    @product = Shoppe::Product.root.find_by_permalink(params[:permalink])
    @variant = Shoppe::Product.find(params[:id])
    if @variant.parent_id == nil
      raise Shoppe::Errors::NotEnoughStock
    end
  end

  private

  def handle_errors(&block)
    begin
      block.call
    rescue Shoppe::Errors::NotEnoughStock => e
      flash[:alert] = "Sorry, #{@product.name} is sold out or not available in that quantity."
      redirect_to product_path(@product.permalink)
    rescue Shoppe::Errors::UnorderableItem => e
      flash[:alert] = "Sorry, an error has occured. Please contact musiccramsessions@gmail.com for help."
      redirect_to product_path(@product.permalink)
    end
  end

  def quantity_valid?(product, quantity)
    stock = product.stock
    return false if stock < 1
    quantity.between?(1, stock)
  end
end
