class ProductsController < ApplicationController

  def index
    redirect_to '/'
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
      @news = News.where('state = ?',true)
  end

  def flash_sale
    @role = Role.find_by_name("designer")

    @designers = @role.users.paginate(:page => pagination_page, :per_page => 2)
    if @designers.size >= 1
    @designer1 = @designers.first
    @count1 = Rating.where('designer_id = ?',@designer1.id).count.to_f
    @sum2 = Rating.where('designer_id = ?',@designer1.id).sum(:score).to_f
    if(@count1 != 0.0)
      @avg_rating1 = (@sum1.to_f/@count1.to_f).to_f
    else
      @avg_rating1 = 0.0
    end
    end
    
    @designer2 = @designers.second
    if @designer2 != nil
    @count2 = Rating.where('designer_id = ?',@designer2.id).count.to_f
    @sum2 = Rating.where('designer_id = ?',@designer2.id).sum(:score).to_f
    if(@count2 != 0.0)
      @avg_rating2 = (@sum2.to_f/@count2.to_f).to_f
    else
      @avg_rating2 = 0.0
    end
  end
  end
  def product_codes
    @product_codes = ProductCode.paginate(:page => pagination_page, :per_page => 4)
  end
  def brand_products
      @brand = Brand.find(params[:id])
      @products = Product.paginate(:page => pagination_page, :per_page => 8).where(["brand_id =?",params[:id]])
  end

  def cat_products
    begin
      if params[:parent] || params[:parent]=="true"
        @cat = ProductType.find(params[:id])      
        @products = Product.aactive.paginate(:page => pagination_page, :per_page => pagination_rows).where(["product_type_id IN (?)",[@cat.id]+@cat.child_ids]) if @cat.present?
      else      
        @cat = ProductType.find(params[:id])
        @products = Product.aactive.paginate(:page => pagination_page, :per_page => pagination_rows).where(["product_type_id =?",params[:id]])
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Record not found !!!"
     redirect_to root_url and return
    end    
  end

  def hot_products
    @products = Product.aactive.paginate(:page => pagination_page, :per_page => 8).where(["super_hot =?",true])
    @banners= Banner.active.order('created_at DESC').where("place = 'hot_slide'")
  end

  def on_sale_products   
    @categories = ProductType.where("parent_id IS NULl").order("name")    
    # Banner small images
    @banner_main_small = Banner.active.order('created_at DESC').where("place = 'main_small'").limit(3)
    # Need to implement best sellers logic
    @best_sellers = Product.aactive    
  end

  def my_profile
#    @user = 
  end

  def search
    if params[:q].present?
      @products = Product.aactive.paginate(:page => pagination_page, :per_page => 10).where(["name like ? OR permalink like ?","#{params[:q]}%","#{params[:q]}%"])
    else
      @products = []
    end
  end

  def show
    @product = Product.active.find_by_permalink(params[:id])    
    @related_products = RelatedProduct.find_all_by_product_id(@product.id) if @product
    if current_user
      @rock_product = ProductRock.find_by_product_id_and_user_id(@product.id,current_user.id) if @product
    end
    form_info    
    if params[:select_property].present?    
      # *** start ***   
      @variant_properties = []
      @multi_variant = []
      @select_index = params[:property_id].to_s
      @total_index = params[:total_index].to_s
      @desc = params[("select_property_"+@select_index).to_sym]
      #@current_variant = Variant.find(params[:v_id].to_i)
=begin
      params[:select_property].each do |k,v|
        if v.present?
          vp =VariantProperty.find_by_description(v)
          if vp.present?            
            @variant_properties <<  vp
          end
        end
      end
      if @variant_properties.present?        
        @variant_properties.each_with_index do |v,index|
          if @variant_properties[index].present? &&  @variant_properties[index+1].present?
            vp = VariantProperty.find_by_variant_id_and_description(@variant_properties[index].variant_id,@variant_properties[index+1].description)
            if vp.present?
              @multi_variant << vp
            end
          end
        end if @variant_properties.size > 1
      end
      if @multi_variant.size > 0
        @current_variant = @multi_variant.last.variant if @variant_properties.present?
      else
        @current_variant = @variant_properties.last.variant if @variant_properties.present?
      end
=end
      @current_variant = @product.active_variants[0] if (@product && @product.active_variants.present?) && !@current_variant.present?
      @cart_item.variant_id = @current_variant.id if @current_variant.present?
      # *** end *** 
         #   render :text => false and return false

    else  
      #@cart_item.variant_id = @product.active_variants.first.try(:id) if @product && @product.active_variants.present?    
      @cart_item.variant_id = params[:variant_id].present? ? params[:variant_id] : @product.active_variants.first.try(:id) if @product && @product.active_variants.present?
      if params[:variant_id] 
        @current_variant = Variant.find(params[:variant_id])
      #   session[:current_variant] = @current_variant.id
      # elsif session[:current_variant]
      #   @current_variant = Variant.find(session[:current_variant])
      else
        @current_variant = @product.active_variants[0] if @product && @product.active_variants.present?
      end
      #render :text => @product.id.to_s and return false
    end
    @news = News.where('state = ?',true) 
    #render :text => @desc and return false
   
  end

  def rock_product    
    @product = Product.active.find(params[:id])
    @flag = true
    @from_flag = false
    if current_user.present?
      @rock_product = ProductRock.where(:user_id=> current_user.id,:product_id=>@product.id).first_or_initialize     
      if params[:unrock].present? && params[:unrock]=="true"
        @rock_product.destroy
        @flag = false
      else
        @rock_product.save
        @message = "Your favorite is updated"
      end
    end

    if(params[:from_icon].to_s == "true")
      @from_flag = true
    else
      @from_flag = false
    end
     respond_to do |format|

       format.js  # { render :layout => false }
    end
    #render :text => "Done" and return false
  end

  def get_property_product     
    #show
    @product = Product.active.find_by_permalink(params[:id])    
    @related_products = RelatedProduct.find_all_by_product_id(@product.id) if @product
    if current_user
      @rock_product = ProductRock.find_by_product_id_and_user_id(@product.id,current_user.id) if @product
    end
    form_info
    if params[:select_click].to_s == "0"
      @property_id = params[:property_id1].to_s
      @total_index = params[:total_index].to_s
      @desc = params[:select_property]["#{@property_id}"].to_s
      #render :text => @desc and return false
      @variant_properties = VariantProperty.where("property_id = ? and LOWER(description) = ? and variant_id in (?)",@property_id,@desc.downcase,@product.variants.map{|x| x.id})
      @properties = VariantProperty.where("property_id != ? and variant_id in (?)",@property_id,@variant_properties.map{|x| x.variant_id})
      @properties2 = @properties
      @pro = @properties2.first.property_id
      @properties = []
      for property in @properties2
      @properties << [property.description] 
            end
      @properties = @properties.compact.uniq
       @select_click = 0
   elsif params[:select_click].to_s == "1"
      @property1=params[:property_id1].to_s
      @property2 = params[:property_id2].to_s
      @desc1 = params[:select_property]["#{@property1}"].to_s

      @desc2 = params[:select_property]["#{@property2}"].to_s
      @variant_properties = VariantProperty.where("property_id = ? and LOWER(description) = ? and variant_id in (?)",@property1,@desc1.downcase,@product.variants.map{|x| x.id})
      @variant_properties2 = VariantProperty.where("property_id = ? and LOWER(description) = ? and variant_id in (?)",@property2,@desc2.downcase,@variant_properties.map{|x| x.variant_id})
      @variant_properties1 = VariantProperty.where("property_id = ? and LOWER(description) = ? and variant_id in (?)",@property1.to_i,@desc1.downcase,@product.variants.map{|x| x.id})
      @properties2 = VariantProperty.where("property_id != ? and variant_id in (?)",@property1.to_i,@variant_properties1.map{|x| x.variant_id})
      @properties22 = []
      for property in @properties2
      @properties22 << [property.description] 
            end
      @pro = @properties2.first.property_id
      @properties22 = @properties22.compact.uniq
      #render :text => @properties22 and return false
      @current_variant = Variant.find(@variant_properties2.first.variant_id)
          @cart_item.variant_id = @current_variant.id
      @select_click = 1

   end
    respond_to do |format|
       format.js 
    end
  end

  def change_variant
    #show
    @product = Product.find(params[:id])
    @variant = Variant.find(params[:variant_id])
    @related_products = RelatedProduct.find_all_by_product_id(@product.id) if @product
    if current_user
      @rock_product = ProductRock.find_by_product_id_and_user_id(@product.id,current_user.id) if @product
    end
    form_info
    @cart_item.variant_id = @variant.id
    if params[:select_property].present?    
      # *** start ***   
      @variant_properties = []
      @multi_variant = []
      params[:select_property].each do |k,v|
        if v.present?
          vp =VariantProperty.find_by_description(v)
          if vp.present?            
            @variant_properties <<  vp
          end
        end
      end
      if @variant_properties.present?        
        @variant_properties.each_with_index do |v,index|
          if @variant_properties[index].present? &&  @variant_properties[index+1].present?
            vp = VariantProperty.find_by_variant_id_and_description(@variant_properties[index].variant_id,@variant_properties[index+1].description)
            if vp.present?
              @multi_variant << vp
            end
          end
        end if @variant_properties.size > 1
      end
      if @multi_variant.size > 0
        @current_variant = @multi_variant.last.variant if @variant_properties.present?
      else
        @current_variant = @variant_properties.last.variant if @variant_properties.present?
      end
      # *** end *** 
    else      
      if params[:variant_id] 
        @current_variant = Variant.find(params[:variant_id])
      #   session[:current_variant] = @current_variant.id
      # elsif session[:current_variant]
      #   @current_variant = Variant.find(session[:current_variant])
      else
        @current_variant = @product.active_variants[0] if @product && @product.active_variants.present?
      end
    end
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
