class ProductsController < ApplicationController

  def index
    products = Product.active.includes(:variants)

    product_types = nil
    if params[:product_type_id].present? && product_type = ProductType.find_by_id(params[:product_type_id])
      product_types = product_type.self_and_descendants.map(&:id)
    end
    if product_types
      @products = products.where('product_type_id IN (?)', product_types)
    else
      @products = products
    end
    @product_types = ProductType.all
  end

  def create
    if params[:q] && params[:q].present?
      @products = Product.standard_search(params[:q]).results
    else
      @products = Product.where('deleted_at IS NULL OR deleted_at > ?', Time.zone.now )
    end

    render :template => '/products/index'
  end

  def show
    @product = Product.active.find(params[:id])
    if current_user
      @rock_product = ProductRock.find_by_product_id_and_user_id(@product.id,current_user.id) if @product
    end
    form_info
    @cart_item.variant_id = @product.active_variants.first.try(:id)
  end

  def rock_product
    @product = Product.active.find(params[:id])
    if current_user.present?
      @rock_product = ProductRock.first_or_initialize(:user_id=> current_user.id,:product_id=>@product.id)
      if params[:unrock]
        @rock_product.destroy
      else
        @rock_product.save
      end
    end
    render :text => "Done" and return false
  end

  private

  def form_info
    @cart_item = CartItem.new
  end

  def featured_product_types
    [ProductType::FEATURED_TYPE_ID]
  end
end
