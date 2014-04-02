class Admin::BlogsController < Admin::BaseController
 	  before_filter :filter_queries , :only=>[:index]
	  #load_and_authorize_resource
	  def filter_queries    
	    @statuses = Blog::STATES.map{|k,v| [v,k]}
	  end

	  def index
	  	#authorize! :blog, current_user
	  	#render :text => (can? :manage, Blog) and return false
	  	if params[:state] == "1"
	      @state = 0;
	      sort = "ASC"
	    else
	      @state = 1;
	      sort = "DESC"
	    end
	    scope = Blog.visible
	    if params[:sorton]
	      field = params[:sorton]
	    else
	      field = 'created_at'
	    end
	    
	    keyword = filter_helper(params)

	    order_by = "#{field} #{sort}"
	    @blogs = scope.paginate(:conditions => keyword, :order => order_by,:per_page=>pagination_rows,:page=>params[:page])
	    @action = "index"
	    @columns = [["Blog","title@string"],["State","state@list"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
	    @nodes = scope.select("title").map{|x| x.title[0] if x.title}.uniq
	  end

	  def new
	  	@blog = Blog.new

	  end

	  def create
	  	I18n.locale = "tcn"    
	  	@blog = Blog.new(user_params)
  		respond_to do |format|
		    if @blog.save
		    	update_all_language(@blog,user_params)
		      format.html  { redirect_to(admin_blogs_path,
		                    :notice => 'blog was successfully created.') }
		    else
		      format.html  { render :action => "new" }
		    end
			end
	  end

	  def edit
	  	@blog = Blog.find(params[:id])

	  end

	  def update
	    err=0
	    if params[:values]
	      (params[:status].casecmp(" Active")) == 0 ? status = 1 : status = 0
	      params[:values].each do |ele|
	          @blog = Blog.find(ele.to_i)
	          unless @blog.update_attribute(user_params)
	            err =1
	          end
	      end
	      if err==1
	        flash[:error] = "Error Occured While Updating File"
	      else
	        flash[:notice] = (params[:status].casecmp(" Active")) == 0 ? 'Activated Successfully' : 'In-activated Successfully'
	      end
	    else
	    	I18n.locale = "tcn"
    		@blog = Blog.find(params[:id])
	  	  respond_to do |format|
	  	    if @blog.update_attributes(user_params)
	  	    	update_all_language(@blog,user_params)
	  	      format.html  { redirect_to(admin_blogs_path,
	  	                    :notice => 'blog was successfully updated.') }
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
	          @blog = Blog.find(ele.to_i)
	          unless @blog.destroy
	            msg = 1
	          end
	      end
	      if msg == 1
	        flash[:error]="Error Occured While Deleting"
	      else
	        flash[:notice]="Data Deleted Successfully"
	      end
	    else
	  	  @blog = Blog.find(params[:id])
	  	  @blog.destroy
	  	  respond_to do |format|
	  	    format.html { redirect_to admin_blogs_path }
	  	  end
	    end
	  end

   	private

  	def user_params
    	params.require(:blog).permit!#(:title, :description, :state,:video_url,:user_id)
  	end
end
