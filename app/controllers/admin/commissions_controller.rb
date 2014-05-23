class Admin::CommissionsController < Admin::BaseController
  before_filter :get_designers
  def get_designers
    @role = Role.find_by_name('designer')
    @designers = @role.users.map { |e| [e.name,e.id]  }
  end
  
  def index
  		#authorize! :commissions, current_user
	  	if params[:state] == "1"
	      @state = 0;
	      sort = "ASC"
	    else
	      @state = 1;
	      sort = "DESC"
	    end
	    scope = Commission.visible
	    if params[:sorton]
	      field = params[:sorton]
	    else
	      field = 'created_at'
	    end
	    
	    keyword = filter_helper(params)

	    order_by = "#{field} #{sort}"
	    @commissions = scope.paginate(:conditions => keyword, :order => order_by,:per_page=>10,:page=>params[:page])
	    @action = "index"
	    @columns = [["Commission","user_id@string"],["Status","state@list"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
	    @nodes = scope.select("user_id").map{|x| x.user_id[0] if x.user_id}.uniq
  end

  def new
  	@commission = Commission.new
  	
  end

  def create
		@commission = Commission.new(user_params)
		respond_to do |format|
	    if @commission.save
	      format.html  { redirect_to(admin_commissions_path,
	                    :notice => 'static page was successfully created.') }
	    else
	      format.html  { render :action => "new" }
	    end
		end
  end

  def edit
  	@commission = Commission.find(params[:id])

  end

  def update
    err=0
    if params[:values]
      (params[:status].casecmp("Active")) == 0 ? status = 1 : status = 0
      params[:values].each do |ele|
        if ele.to_i > 0
          @commission = Commission.find(ele.to_i)
          unless @commission.update_attribute(:state, status )
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
    	@commission = Commission.find(params[:id])
  	  respond_to do |format|
  	    if @commission.update_attributes(user_params)
  	      format.html  { redirect_to(admin_commissions_path,
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
        if ele.to_i > 0
          @commission = Commission.find(ele.to_i)
          unless @commission.destroy
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
  	  @commission = Commission.find(params[:id])
  	  @commission.destroy
  	  respond_to do |format|
  	    format.html { redirect_to admin_commissions_path }
  	  end
    end
  end

 	private

  def user_params
    params.require(:commission).permit(:user_id, :commission)
  end
end
