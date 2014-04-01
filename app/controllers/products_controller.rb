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

  def my_favorites
      prodcut_rocks= ProductRock.find_all_by_user_id(current_user.id).map(&:product_id)
      @fav_products = Product.paginate(:page => pagination_page, :per_page => pagination_rows).where(["id in (?)",prodcut_rocks])
  end

  def brand_products
      @brand = Brand.find(params[:id])
      @products = Product.paginate(:page => pagination_page, :per_page => pagination_rows).where(["brand_id =?",params[:id]])
  end

  def cat_products
    @cat = ProductType.find(params[:id])
    @products = Product.paginate(:page => pagination_page, :per_page => pagination_rows).where(["product_type_id =?",params[:id]])
  end

  def hot_products
    @products = Product.paginate(:page => pagination_page, :per_page => pagination_rows).where(["super_hot =?",true])
  end
  def my_profile
#    @user = 
  end

  def show
    @product = Product.active.find(params[:id])
    if current_user
      @rock_product = ProductRock.find_by_product_id_and_user_id(@product.id,current_user.id) if @product
    end
    form_info
    @cart_item.variant_id = @product.active_variants.first.try(:id)
    if params[:variant_id] 
      @current_variant = Variant.find(params[:variant_id])
      session[:current_variant] = @current_variant.id
    elsif session[:current_variant]
      @current_variant = Variant.find(session[:current_variant])
    else
      @current_variant = @product.active_variants[0]
    end
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

  def get_property_product
    #@q_string = []
    @variant_properties = []
    @multi_variant = []
    params[:select_property].each do |k,v|
      if v[0].present?
        vp =VariantProperty.find_by_description(v[0])
        if vp.present?
          @variant_properties <<  vp
        end
      end
    end
    @variant_properties.each_with_index do |v,index|
       if @variant_properties[index].present? &&  @variant_properties[index+1].present?
          vp = VariantProperty.find_by_variant_id_and_description(@variant_properties[index].variant_id,@variant_properties[index+1].description)
          if vp.present?
            @multi_variant << vp
          end
       end
    end if @variant_properties.size > 1

    #@new_q_string = @q_string.join(" OR ")
    # variant_property = VariantProperty.find_by_description_and_property_id(params[:variant_val],params[:property_id])
    show
    if @multi_variant.size > 0
      @current_variant = @multi_variant.last.variant if @variant_properties.present?
    else
      @current_variant = @variant_properties.last.variant if @variant_properties.present?
    end
    # @current_variant = variant_property.variant
    respond_to do |format|
       format.js 
    end
  end

  def change_variant
    show
    respond_to do |format|
       format.js  # { render :layout => false }
    end
  end

  private

  def form_info
    @cart_item = CartItem.new
  end

  def featured_product_types
    [ProductType::FEATURED_TYPE_ID]
  end
end
