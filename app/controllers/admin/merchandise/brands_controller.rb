class Admin::Merchandise::BrandsController < Admin::BaseController
  def index
    keyword = filter_helper(params)
    @brands = Brand.where(keyword).paginate(:page => pagination_page, :per_page => pagination_rows)
    if current_user.designer?
      @brands = @brands.where(["user_id =?",current_user.id])
    end
    @action = "index"
    @columns = [["Name","name@string"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
    @nodes = Brand.all.select("name").map{|x| x.name[0] if x.name}.uniq                                                                                  
  end

  def show
    @brand = Brand.find(params[:id])
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(allowed_params)
    if @brand.save
      flash[:notice] = "Successfully created brand."
      redirect_to admin_merchandise_brand_url(@brand)
    else
      render :action => 'new'
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(allowed_params)
      flash[:notice] = "Successfully updated brand."
      redirect_to admin_merchandise_brand_url(@brand)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @brand = Brand.find(params[:id])

    if @brand.products.empty?
      @brand.destroy
    else
      flash[:alert] = "Sorry this brand is already associated with a product.  You can not delete this brand."
    end

    redirect_to admin_merchandise_brands_url
  end

  private

  def allowed_params
    params.require(:brand).permit(:name,:user_id)
  end

end
