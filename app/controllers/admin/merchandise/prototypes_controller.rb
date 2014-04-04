class Admin::Merchandise::PrototypesController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json
  def index
    keyword = filter_helper(params)
    @prototypes = Prototype.admin_grid(params).order(sort_column + " " + sort_direction).where(keyword).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
    if current_user.designer?
      @prototypes = @prototypes.where(["user_id =?",current_user.id])
    end   
    @action = "index"
    @columns = [["Name","name@string"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
    @nodes = Prototype.select("name").map{|x| x.name[0] if x.name}.uniq                                              
  end

  def new
    @all_properties = Property.all
    if current_user.designer?
      @all_properties = @all_properties.where(["user_id =?",current_user.id])
    end 
    if @all_properties.empty?
      flash[:notice] = "You must create a property before you create a prototype."
      redirect_to new_admin_merchandise_property_path
    else
      @prototype      = Prototype.new(:active => true)
      @prototype.properties.build
    end
  end

  def create
    I18n.locale = "tcn"
    @prototype = Prototype.new(allowed_params)
    if @prototype.save
      update_all_language(@prototype,allowed_params)
      redirect_to :action => :index
    else
      @all_properties = Property.all
      if current_user.designer?
        @all_properties = @all_properties.where(["user_id =?",current_user.id])
      end 
      flash[:error] = "The prototype property could not be saved"
      render :action => :new
    end
  end

  def edit
    @all_properties = Property.all
    if current_user.designer?
      @all_properties = @all_properties.where(["user_id =?",current_user.id])
    end 
    @prototype = Prototype.includes(:properties).find(params[:id])
  end

  def update
    I18n.locale = "tcn"
    @prototype = Prototype.find(params[:id])
    @prototype.property_ids = params[:prototype][:property_ids]
    if @prototype.update_attributes(allowed_params)
      update_all_language(@prototype,allowed_params)
      redirect_to :action => :index
    else
      @all_properties = Property.all
      if current_user.designer?
        @all_properties = @all_properties.where(["user_id =?",current_user.id])
      end 
      render :action => :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    if @prototype.active
      @prototype.active = false
    else
      @prototype.active = true
    end
    @prototype.save

    redirect_to :action => :index
  end
  private

  def allowed_params
    params.require(:prototype).permit(:user_id, :name, :active, :property_ids => [] )
  end

  def sort_column
    Prototype.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
