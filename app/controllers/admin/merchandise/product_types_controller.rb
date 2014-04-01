class Admin::Merchandise::ProductTypesController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json
  def index
    keyword = filter_helper(params)
    @product_types = ProductType.admin_grid(params).order(sort_column + " " + sort_direction).where(keyword).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
    @action = "index"
    @columns = [["Name","name@string"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
    @nodes = ProductType.select("name").map{|x| x.name[0] if x.name}.uniq
  end

  def show
    @product_type = ProductType.find(params[:id])
    respond_with(@product_type)
  end

  def new
    @product_type = ProductType.new
    form_info
  end

  def create
    I18n.locale = "tcn"
    @product_type = ProductType.new(allowed_params)    
    if @product_type.save
      update_all_language(@product_type,allowed_params)
      redirect_to :action => :index
    else
      form_info
      flash[:error] = "The product_type could not be saved"
      render :action => :new
    end
  end

  def edit
    @product_type = ProductType.find(params[:id])
    form_info
  end

  def update
    I18n.locale = "tcn"
    @product_type = ProductType.find(params[:id])

    if @product_type.update_attributes(allowed_params)
      update_all_language(@product_type,allowed_params)
      redirect_to :action => :index
    else
      form_info
      render :action => :edit
    end
  end

  def destroy
    @product_type = ProductType.find(params[:id])
    @product_type.active = false
    @product_type.save

    redirect_to :action => :index
  end

  private

  def allowed_params
    params.require(:product_type).permit( :name, :parent_id ,:main_menu)
  end

  def form_info
    @product_types = ProductType.all
  end

  def sort_column
    ProductType.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
