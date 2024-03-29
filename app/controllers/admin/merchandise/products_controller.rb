class Admin::Merchandise::ProductsController < Admin::BaseController
  helper_method :sort_column, :sort_direction, :product_types
  respond_to :html, :json
  authorize_resource

  def index
    params[:page] ||= 1

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
    @products = Product.admin_grid(params).order(sort_column + " " + sort_direction).where(keyword).
                                              paginate(:page => pagination_page, :per_page => pagination_rows)
    if current_user.designer?
      @products = @products.where(["user_id =?",current_user.id])
    end
    @action = "index"
    @columns = [["Name","name@string"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
    @nodes = @products.select("name").map{|x| x.name[0] if x.name}.uniq                                              
  end

  def show
    @product = Product.find(params[:id])
    respond_with(@product) 
  end

  def new
    form_info
    if @prototypes.empty?
      flash[:notice] = "You must create a prototype before you create a product."
      redirect_to new_admin_merchandise_prototype_url
    else
      @product            = Product.new
      @product.prototype  = Prototype.new
    end
  end

  def create
    I18n.locale = "tcn"
    @product = Product.new(allowed_params)        
    if @product.save      
      update_all_language(@product,allowed_params)
      flash[:notice] = "Success, You should create a variant for the product."
      redirect_to edit_admin_merchandise_products_description_url(@product)
    else
      form_info
      flash[:error] = "The product could not be saved"
      render :action => :new
    end
  rescue
    render :text => "Please make sure you have solr started... Run this in the command line => bundle exec rake sunspot:solr:start"
  end

  def edit
    @product = Product.includes(:properties,:product_properties, {:prototype => :properties}).find(params[:id])
    form_info
  end

  def update
    I18n.locale = "tcn"
    @product = Product.find(params[:id])

    if @product.update_attributes(allowed_params)
      update_all_language(@product,allowed_params)
      redirect_to admin_merchandise_product_url(@product)
    else
      form_info
      render :action => :edit#, :layout => 'admin_markup'
    end
  end

  def add_properties
    prototype  = Prototype.includes(:properties).find(params[:id])
    @properties = prototype.properties
    all_properties = Property.all

    @properties_hash = all_properties.inject({:active => [], :inactive => []}) do |h, property|
      if  @properties.detect{|p| (p.id == property.id) }
        h[:active] << property.id
      else
        h[:inactive] << property.id
      end
      h
    end
    
      render :json => @properties_hash.to_json     
  end

  def activate
    @product = Product.find_by_permalink(params[:id])
    # render :text => @product.deleted_at.inspect and return false
    @product.deleted_at = nil
    if @product.save
      redirect_to admin_merchandise_product_url(@product)      
    else      
      flash[:alert] = @product.errors.full_messages.join(",")
      redirect_to edit_admin_merchandise_products_description_url(@product)
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.deleted_at ||= Time.zone.now
    @product.save

    redirect_to admin_merchandise_product_url(@product)
  end

  private

    def allowed_params
      params.require(:product).permit!#(:id,:condition_of_product,:super_hot,:gender,:name,:user_id, :description, :product_keywords, :set_keywords, :product_type_id,
                                      #:prototype_id, :shipping_category_id, :permalink, :available_at, :deleted_at,
                                      #:meta_keywords, :meta_description, :featured, :description_markup, :brand_id,
                                      #product_properties_attributes: [:product_id, :property_id, :position, :description])
    end

    def form_info
      @prototypes               = Prototype.all.collect{|pt| [pt.name, pt.id]}
      @all_properties           = Property.all
      @select_shipping_category = ShippingCategory.all.collect {|sc| [sc.name, sc.id]}
      @brands        = Brand.order(:name).collect {|ts| [ts.name, ts.id]}
    end

    def product_types
      @product_types ||= ProductType.all
    end

      def sort_column
        Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
      end

      def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
      end

end
