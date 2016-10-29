class ProductsController < ApplicationController
  def index
    @products = Shoppe::Product.root.ordered.includes(:product_categories, :variants)
  end

  def show
    @product = Shoppe::Product.root.find_by_permalink(params[:permalink])
  end

  def buy
    @product = Shoppe::Product.root.find_by_permalink!(params[:permalink])
    current_order.order_items.add_item(@product, 1)
    redirect_to merch_path, :notice => "Product has been added successfuly!"
  end
end
