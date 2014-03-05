class Admin::Merchandise::RelatedProductsController < Admin::BaseController
  before_filter :check_product

  def check_product
    if params[:product_id].present?
      @product = Product.find(params[:product_id])
    end  
  end

  def index
    keyword = filter_helper(params)
    @related_products = RelatedProduct.where(keyword).paginate(:page => pagination_page, :per_page => pagination_rows)
    @action = "index"
    @columns = [["Related Product","related_product_id@string"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
    @nodes = RelatedProduct.all.select("related_product_id").map{|x| x.related_product_id[0] if x.related_product_id}.uniq                                                                                  
  end

  def show
    @related_product = RelatedProduct.find(params[:id])
  end

  def new
    @related_product = RelatedProduct.new
    @product = Product.find(params[:product_id])
    @products = Product.where(["id != ?",@product.id])
    @related_product.product_id = params[:product_id]
  end

  def create
    @related_product = RelatedProduct.new(allowed_params)
    if @related_product.save
      flash[:notice] = "Successfully created related product."
      redirect_to admin_merchandise_product_related_products_url(@product)
    else
      @product = Product.find(params[:product_id])
      @products = Product.where(["id not in ?",params[:product_id]])
      render :action => 'new'
    end
  end

  def edit
    @related_product = RelatedProduct.find(params[:id])
    @product = Product.find(params[:product_id])
    @products = Product.where(["id not in ?",params[:product_id]])
  end

  def update
    @related_product = RelatedProduct.find(params[:id])
    if @related_product.update_attributes(allowed_params)
      flash[:notice] = "Successfully updated related product."
      redirect_to admin_merchandise_product_related_product_url(@product)
    else
      @product = Product.find(params[:product_id])
      @products = Product.where(["id not in ?",params[:product_id]])
      render :action => 'edit'
    end
  end

  def destroy
    @related_product = RelatedProduct.find(params[:id])
    if @related_product.destroy
      flash[:alert] = "Deleted Successfully !."
    else
      flash[:alert] = "Sorry this related product is not destroyed ."
    end

    redirect_to admin_merchandise_product_related_products_url
  end

  private

  def allowed_params
    params.require(:related_product).permit(:product_id,:related_product_id)
  end

end
