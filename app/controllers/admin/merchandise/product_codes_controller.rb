class Admin::Merchandise::ProductCodesController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json
  def index
    keyword = filter_helper(params)
    @product_codes = ProductCode.admin_grid(params).order(sort_column + " " + sort_direction).where(keyword).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
    @action = "index"
    @columns = [["Title","title@string"],["Discount","discount@float"]]    
    @nodes = ProductCode.select("title").map{|x| x.title[0] if x.title}.uniq
  end

  def show
    @product_code = ProductCode.find(params[:id])
    respond_with(@product_code)
  end

  def new
    @product_code = ProductCode.new
    @products = Product.all
    @variants = Variant.all
    #form_info
  end

  def create
    I18n.locale = "tcn"
    @product_code = ProductCode.new(allowed_params)
    if(ProductCode.validates_product_code(params[:select_product1],params[:select_product2],params[:select_product3],params[:select_product4]))
    if @product_code.save
      if(params[:select_product1] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.variant_id = params[:select_product1].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product2] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.variant_id = params[:select_product2].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product3] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.variant_id = params[:select_product3].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product4] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.variant_id = params[:select_product4].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      update_all_language(@product_code,allowed_params)
      redirect_to :action => :index
    else
      form_info
       @variants = Variant.all
      flash[:error] = "The product_code could not be saved"
      render :action => :new
    end
  else
    form_info
       @variants = Variant.all
      flash[:error] = "The product_code could not be saved as product selected should be 2 or more than 2"
      render :action => :new
  end
  end

  def edit
    @product_code = ProductCode.find(params[:id])
    @products = Product.all
     @variants = Variant.all
    form_info
  end

  def update
    I18n.locale = "tcn"
    @product_code = ProductCode.find(params[:id])
     @variants = Variant.all
    if(ProductCode.validates_product_code(params[:select_product1],params[:select_product2],params[:select_product3],params[:select_product4]))
    if @product_code.update_attributes(allowed_params)
      update_all_language(@product_code,allowed_params)
      @product_code.product_code_products.destroy_all
      if(params[:select_product1] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.variant_id = params[:select_product1].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product2] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.variant_id = params[:select_product2].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product3] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.variant_id = params[:select_product3].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product4] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.variant_id = params[:select_product4].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      redirect_to :action => :index
    else
      form_info
      @products = Product.all
      render :action => :edit
    end
  else
      form_info
      @products = Product.all
      render :action => :edit
  end
  end

  def destroy
    @product_code = ProductCode.find(params[:id])
    if @product_code.active
      @product_code.active = false
    else
      @product_code.active = true
    end
    @product_code.save

    redirect_to :action => :index
  end
  def update_price
    @variant = Variant.find_by_id(params[:change_to])
    @from_pr = params[:from_pr].to_i
    @discount = params[:discount].to_f
    @variant1 = Variant.find_by_id(params[:one])
      @variant2 = Variant.find_by_id(params[:two])
      @variant3 = Variant.find_by_id(params[:three])
if(@variant1.present?)
      if @variant1.price_after_discount.present? 
        @val1 = @variant1.price_after_discount
      else
        @val1 = @variant1.price
      end
    else
      @val1 = 0.0
    end
    if(@variant2.present?)
      if @variant2.price_after_discount.present? 
        @val2 = @variant2.price_after_discount
      else
        @val2 = @variant2.price
      end
    else
      @val2 = 0.0
    end
     if(@variant3.present?)
      if @variant3.price_after_discount.present? 
        @val3 = @variant3.price_after_discount
      else
        @val3 = @variant3.price
      end
    else
      @val3 = 0.0
    end
    if(@variant.present?)
      if @variant.price_after_discount.present? 
        @val = @variant.price_after_discount
      else
        @val = @variant.price
      end
    else
      @val = 0.0
    end
    
    respond_to do |format|

       format.js 
    end
  end
  def update_price_discount
    @discount = params[:discount].to_f
    @variant1 = Variant.find_by_id(params[:select1_val])
    @variant2 = Variant.find_by_id(params[:select2_val])
    @variant3 = Variant.find_by_id(params[:select3_val])
    @variant4 = Variant.find_by_id(params[:select4_val])
    if(@variant1.present?)
      if @variant1.price_after_discount.present? 
        @val1 = @variant1.price_after_discount
      else
        @val1 = @variant1.price
      end
    else
      @val1 = 0.0
    end
    if(@variant2.present?)
      if @variant2.price_after_discount.present? 
        @val2 = @variant2.price_after_discount
      else
        @val2 = @variant2.price
      end
    else
      @val2 = 0.0
    end
    if(@variant3.present?)
      if @variant3.price_after_discount.present? 
        @val3 = @variant3.price_after_discount
      else
        @val3 = @variant3.price
      end
    else
      @val3 = 0.0 
    end
    if(@variant4.present?)
      if @variant4.price_after_discount.present? 
        @val4 = @variant4.price_after_discount
      else
        @val4 = @variant4.price
      end
    else
      @val4 = 0.0
    end
    @total_before_discount = @val1+@val2+@val3+@val4
    @total_after_discount = @total_before_discount - ((@total_before_discount*@discount).to_f/100.0)
    @val1_discount = @val1 - ((@val1*@discount).to_f/100.0)
    @val2_discount = @val2 - ((@val2*@discount).to_f/100.0)
    @val3_discount = @val3 - ((@val3*@discount).to_f/100.0)
    @val4_discount = @val4 - ((@val4*@discount).to_f/100.0)
    respond_to do |format|

       format.js 
    end
  end
  private

  def allowed_params
    params.require(:product_code).permit( :title, :discount)
  end

  def form_info
    @product_codes = ProductCode.all
  end

  def sort_column
    ProductCode.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
