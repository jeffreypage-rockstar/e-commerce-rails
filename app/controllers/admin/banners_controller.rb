class Admin::BannersController < Admin::BaseController
  def index
  		#authorize! :banners, current_user
	  	if params[:state] == "1"
	      @state = 0;
	      sort = "ASC"
	    else
	      @state = 1;
	      sort = "DESC"
	    end
	    scope = Banner.visible
	    if params[:sorton]
	      field = params[:sorton]
	    else
	      field = 'created_at'
	    end
	    
	    keyword = filter_helper(params)

	    order_by = "#{field} #{sort}"
	    @banners = scope.paginate(:conditions => keyword, :order => order_by,:per_page=>10,:page=>params[:page])
	    @action = "index"
	    @columns = [["Banner","title@string"],["Status","state@list"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
	    @nodes = scope.select("title").map{|x| x.title[0] if x.title}.uniq
  end

  def new
  	@banner = Banner.new
  	
  end

  def create
  	@banner = Banner.new(user_params)
		respond_to do |format|
	    if @banner.save
	   		format.html  { redirect_to(admin_banners_path,
	                    :notice => 'Banner was successfully created.') }
	    else
	      format.html  { render :action => "new" }
	    end
		end
  end

  def edit
  	@banner = Banner.find(params[:id])
  end

  def update
    err=0
    if params[:values]
      (params[:status].casecmp(" Active")) == 0 ? status = 1 : status = 0
      params[:values].each do |ele|
          @banner = Banner.find(ele.to_i)
          unless @banner.update_attribute(:status, status )
            err =1
          end
      end
      if err==1
        flash[:error] = "Error Occured While Updating File"
      else
        flash[:notice] = (params[:status].casecmp(" Active")) == 0 ? 'Activated Successfully' : 'In-activated Successfully'
      end
    else
    	@banner = Banner.find(params[:id])
  	  respond_to do |format|
  	    if @banner.update_attributes(user_params)
  	      format.html  { redirect_to(admin_banners_path,
  	                    :notice => 'banner was successfully updated.') }
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
          @banner = Banner.find(ele.to_i)
          unless @banner.destroy
            msg = 1
          end
      end
      if msg == 1
        flash[:error]="Error Occured While Deleting"
      else
        flash[:notice]="Data Deleted Successfully"
      end
    else
  	  @banner = Banner.find(params[:id])
  	  @banner.destroy
  	  respond_to do |format|
  	    format.html { redirect_to admin_banners_path }
  	  end
    end
  end

 	private

  def user_params
    params.require(:banner).permit!
  end
end
