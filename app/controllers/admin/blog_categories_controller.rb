class Admin::BlogCategoriesController < Admin::BaseController
 	  before_filter :filter_queries , :only=>[:index]
	  
	  def filter_queries    
	    @statuses = BlogCategory::STATES.map{|k,v| [v,k]}
	  end

	  def index
	  	# authorize! :blog_categories, current_user
	  	if params[:state] == "1"
	      @state = 0;
	      sort = "ASC"
	    else
	      @state = 1;
	      sort = "DESC"
	    end
	    scope = BlogCategory.visible
	    if params[:sorton]
	      field = params[:sorton]
	    else
	      field = 'created_at'
	    end
	    
	    keyword = filter_helper(params)

	    order_by = "#{field} #{sort}"
	    @blog_categories = scope.paginate(:conditions => keyword, :order => order_by,:per_page=>pagination_rows,:page=>params[:page])
	    @action = "index"
	    @columns = [["BlogCategory","name@string"],["State","state@list"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
	    @nodes = scope.select("name").map{|x| x.name[0] if x.name}.uniq
	  end

	  def new
	  	@blog_category = BlogCategory.new
	  end

	  def create
	  	I18n.locale = "tcn"
  		@blog_category = BlogCategory.new(user_params)
  		respond_to do |format|
		    if @blog_category.save		    	
		    	update_all_language(@blog_category,user_params)
		      format.html  { redirect_to(admin_blog_categories_path,
		                    :notice => 'blog_category was successfully created.') }
		    else		    	
		      format.html  { render :action => "new" }
		    end
			end
	  end

	  def edit	  	
	  	@blog_category = BlogCategory.find(params[:id])
	  end

	  def update	  		  	
	    err=0
	    if params[:values]
	      (params[:status].casecmp("Active")) == 0 ? status = 1 : status = 0
	      params[:values].each do |ele|
	      	if ele.to_i > 0
	          @blog_category = BlogCategory.find(ele.to_i)
	          @blog_category.state=status

	          unless @blog_category.save
	            err =1
	          end
	      	end
	      end
	      if err==1
	        flash[:error] = "Error Occured While Updating File"
	      else
	        flash[:notice] = (params[:status].casecmp("Active")) == 0 ? 'Activated Successfully' : 'In-activated Successfully'
	      end
	    else
	    	I18n.locale = "tcn"
	    	@blog_category = BlogCategory.find(params[:id])
	  	  respond_to do |format|
	  	    if @blog_category.update_attributes(user_params)
	  	    	update_all_language(@blog_category,user_params)
	  	      format.html  { redirect_to(admin_blog_categories_path,
	  	                    :notice => 'blog_category was successfully updated.') }
	  	    else
	  	      format.html  { render :action => "edit" }
	  	    end
	  	  end
	    end
	  end

	  def destroy
	    if params[:values]
	      msg = 0
	      params[:values].each do |ele|
	      	if ele.to_i > 0
	          @blog_category = BlogCategory.find(ele.to_i)
	          unless @blog_category.destroy
	            msg = 1
	          end
	      	end
	      end
	      if msg == 1
	        flash[:error]="Error Occured While Deleting"
	      else
	        flash[:notice]="Data Deleted Successfully"
	      end
	    else
	  	  @blog_category = BlogCategory.find(params[:id])
	  	  @blog_category.destroy
	  	  respond_to do |format|
	  	    format.html { redirect_to admin_blog_categories_path }
	  	  end
	    end
	  end

   	private

  	def user_params
    	params.require(:blog_category).permit!#(:name, :description, :state,:video_url,:user_id)
  	end
end
