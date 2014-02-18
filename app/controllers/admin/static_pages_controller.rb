class Admin::StaticPagesController < Admin::BaseController
  def index
  		#authorize! :static_pages, current_user
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
	    @static_pages = scope.paginate(:conditions => keyword, :order => order_by,:per_page=>10,:page=>params[:page])
	    @action = "index"
	    @columns = [["StaticPage","eng_title@string"],["Status","state@list"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
	    @nodes = scope.select("eng_title").map{|x| x.eng_title[0] if x.eng_title}.uniq
	  end

	  def new
	  	@static_page = StaticPage.new
	  end

	  def create
  		@static_page = StaticPage.new(user_params)
  		respond_to do |format|
		    if @static_page.save
		      format.html  { redirect_to(admin_static_pages_path,
		                    :notice => 'static page was successfully created.') }
		    else
		      format.html  { render :action => "new" }
		    end
			end
	  end

	  def edit
	  	@static_page = StaticPage.find(params[:id])

	  end

	  def update
	    err=0
	    if params[:values]
	      (params[:status].casecmp(" Active")) == 0 ? status = 1 : status = 0
	      params[:values].each do |ele|
	          @static_page = StaticPage.find(ele.to_i)
	          unless @static_page.update_attribute(:status, status )
	            err =1
	          end
	      end
	      if err==1
	        flash[:error] = "Error Occured While Updating File"
	      else
	        flash[:notice] = (params[:status].casecmp(" Active")) == 0 ? 'Activated Successfully' : 'In-activated Successfully'
	      end
	    else
	    	@static_page = StaticPage.find(params[:id])
	  	  respond_to do |format|
	  	    if @static_page.update_attributes(user_params)
	  	      format.html  { redirect_to(admin_static_pages_path,
	  	                    :notice => 'static page was successfully updated.') }
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
	          @static_page = StaticPage.find(ele.to_i)
	          unless @static_page.destroy
	            msg = 1
	          end
	      end
	      if msg == 1
	        flash[:error]="Error Occured While Deleting"
	      else
	        flash[:notice]="Data Deleted Successfully"
	      end
	    else
	  	  @static_page = StaticPage.find(params[:id])
	  	  @static_page.destroy
	  	  respond_to do |format|
	  	    format.html { redirect_to admin_static_pages_path }
	  	  end
	    end
	  end

   	private

	  def user_params
	    params.require(:static_page).permit(:eng_title, :eng_content, :state)
	  end
end
