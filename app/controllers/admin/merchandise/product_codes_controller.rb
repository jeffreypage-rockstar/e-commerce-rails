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
    
    #form_info
  end

  def create
    I18n.locale = "tcn"
    @product_code = ProductCode.new(allowed_params)
    if(ProductCode.validates_product_code(params[:select_product1],params[:select_product2],params[:select_product3],params[:select_product4]))
    if @product_code.save
      if(params[:select_product1] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.product_id = params[:select_product1].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product2] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.product_id = params[:select_product2].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product3] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.product_id = params[:select_product3].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product4] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.product_id = params[:select_product4].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      update_all_language(@product_code,allowed_params)
      redirect_to :action => :index
    else
      form_info
      flash[:error] = "The product_code could not be saved"
      render :action => :new
    end
  else
    form_info
      flash[:error] = "The product_code could not be saved as product selected should be 2 or more than 2"
      render :action => :new
  end
  end

  def edit
    @product_code = ProductCode.find(params[:id])
    @products = Product.all
    form_info
  end

  def update
    I18n.locale = "tcn"
    @product_code = ProductCode.find(params[:id])
    if(ProductCode.validates_product_code(params[:select_product1],params[:select_product2],params[:select_product3],params[:select_product4]))
    if @product_code.update_attributes(allowed_params)
      update_all_language(@product_code,allowed_params)
      @product_code.product_code_products.destroy_all
      if(params[:select_product1] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.product_id = params[:select_product1].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product2] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.product_id = params[:select_product2].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product3] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.product_id = params[:select_product3].to_i
          @product_code_product.product_code_id = @product_code.id
          @product_code_product.save
      end
      if(params[:select_product4] != "")
          @product_code_product = ProductCodeProduct.new
          @product_code_product.product_id = params[:select_product4].to_i
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
    @product = Product.find(params[:change_to])
    @from_pr = params[:from_pr].to_i
    @discount = params[:discount].to_f
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
