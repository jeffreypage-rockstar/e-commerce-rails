class Admin::NewsesController < Admin::BaseController

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
	    
	    if params[:sorton]
	      field = params[:sorton]
	    else
	      field = 'created_at'
	    end
	    
	    keyword = filter_helper(params)

	    order_by = "#{field} #{sort}"
	    @newses = News.paginate(:conditions => keyword, :order => order_by,:per_page=>pagination_rows,:page=>params[:page])
	    @columns = [["Name","title@string"],["Created At","description@date"],["Updated At","updated_at@date"]]    
      	@nodes = @newses.select("title").map{|x| x.title[0] if x.title}.uniq
	    
	  end

	  def new
	  	@news = News.new

	  end

	  def create
	  	I18n.locale = "tcn"    
	  	@news = News.new(user_params)
  		respond_to do |format|
		    if @news.validate && @news.save!
		    	update_all_language(@news,user_params)
		      format.html  { redirect_to(admin_newses_path,
		                    :notice => 'News was successfully created.') }
		    else
		      format.html  { render :action => "new" }
		    end
			end
	  end

	  def edit
	  	@news = News.find(params[:id])

	  end

	  def update
	    err=0
	    if params[:values]
	      (params[:status].casecmp(" Active")) == 0 ? status = 1 : status = 0
	      params[:values].each do |ele|
	          @news = News.find(ele.to_i)
	          unless @news.update_attribute(user_params)
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
    		@news = News.find(params[:id])
	  	  respond_to do |format|
	  	    if (@news.validate && @news.update_attributes(user_params))
	  	    	update_all_language(@news,user_params)
	  	      format.html  { redirect_to(admin_newses_path,
	  	                    :notice => 'News was successfully updated.') }
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
	          @news = News.find(ele.to_i)
	          unless @news.destroy
	            msg = 1
	          end
	      end
	      if msg == 1
	        flash[:error]="Error Occured While Deleting"
	      else
	        flash[:notice]="Data Deleted Successfully"
	      end
	    else
	  	  @news = News.find(params[:id])
	  	  @news.destroy
	  	  respond_to do |format|
	  	    format.html { redirect_to admin_newses_path }
	  	  end
	    end
	  end

   	private

  	def user_params
    	params.require(:news).permit!#(:title, :description, :state,:video_url,:user_id)
  	end
end
