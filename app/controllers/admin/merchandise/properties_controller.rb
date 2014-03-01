class Admin::Merchandise::PropertiesController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json
  def index
    if params[:state] == "1"
      @state = 0;
      sort = "ASC"
    else
      @state = 1;
      sort = "DESC"
    end
    scope = StaticPage.visible
    if params[:sorton]
      field = params[:sorton]
    else
      field = 'created_at'
    end
    
    keyword = filter_helper(params)

    order_by = "#{field} #{sort}"
    @properties = Property.admin_grid(params).order(sort_column + " " + sort_direction).where(keyword).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
    if current_user.designer?
      @properties = @properties.where(["user_id =?",current_user.id])
    end                            

    @action = "index"
    @columns = [["Name","identifing_name@string"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
    @nodes = Property.all.select("identifing_name").map{|x| x.identifing_name[0] if x.identifing_name}.uniq                                             
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(allowed_params)
    if @property.save
      redirect_to :action => :index
    else
      flash[:error] = "The property could not be saved"
      render :action => :new
    end
  end

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])
    if @property.update_attributes(allowed_params)
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.active = false
    @property.save

    redirect_to :action => :index
  end

  private

  def allowed_params
    params.require(:property).permit(:identifing_name, :display_name, :active,:user_id)
  end

  def sort_column
    Property.column_names.include?(params[:sort]) ? params[:sort] : "identifing_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
