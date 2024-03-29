class Admin::UsersController < Admin::BaseController
  helper_method :sort_column, :sort_direction
  before_filter :get_image

  def get_image
    if params[:id]
      user_images = User.find(params[:id]).images
      @user_image = user_images.present? ? user_images[0] : User.find(params[:id]).images.new
    end
  end

  def index
    authorize! :view_users, current_user
    if params[:type]
      @role = Role.find_by_name(params[:type])
      keyword = filter_helper(params)
      # order_by = "#{field} #{sort}"
      # render :json => params[:type] and return false
      if(params[:type] == "super_administrator")
      @users_admin = User.none
      @role1 = Role.find_by_name("administrator")
      
      @users_admin = @role.users.merge(@role1.users)
      
      if(@users_admin.size > 0)
      @users = @users_admin.admin_grid(params).order(sort_column + " " + sort_direction).where(keyword).
                                                 paginate(:page => pagination_page, :per_page => pagination_rows)

      else
      @users = User.none
      end
      else
      @users = @role.users.admin_grid(params).order(sort_column + " " + sort_direction).where(keyword).
                                                 paginate(:page => pagination_page, :per_page => pagination_rows)
      end
      @action = "index"
      @columns = [["Name","first_name@string"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
      @nodes = @role.users.select("first_name").map{|x| x.first_name[0] if x.first_name}.uniq
    else
      keyword = filter_helper(params)
      @users =  User.admin_grid(params).order(sort_column + " " + sort_direction).where(keyword).
                                      paginate(:page => pagination_page, :per_page => pagination_rows)
                                      @action = "index"
      @columns = [["Name","first_name@string"],["Created At","created_at@date"],["Updated At","updated_at@date"]]    
      @nodes = @users.select("first_name").map{|x| x.first_name[0] if x.first_name}.uniq
    end                                    
  end

  def show
    @user = User.includes([:shipments, :finished_orders, :return_authorizations]).find(params[:id])
    add_to_recent_user(@user)
  end

  def new
    @user = User.new
    authorize! :create_users, current_user
    form_info
  end

  def create
    @user = User.new(user_params)
    authorize! :create_users, current_user
    if @user.save
      @user.deliver_activation_instructions!
      add_to_recent_user(@user)
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to admin_users_url
    else
      form_info
      render :action => :new
    end
  end

  def edit
    @user = User.includes(:roles).find(params[:id])
    authorize! :create_users, current_user
    form_info
  end

  def destroy
    @user = User.includes(:roles).find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

  def update
    params[:user][:role_ids] ||= []
    @user = User.includes(:roles).find(params[:id])
    authorize! :create_users, current_user
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.name} has been updated."
      redirect_to admin_users_url
    else
      form_info
      render :action => :edit
    end
  end

  private

  def user_params
    params.require(:user).permit!#(:password, :password_confirmation, :first_name, :last_name, :email, :state, :role_ids => [])
  end

  def form_info
    @all_roles = Role.all
    @states    = ['inactive', 'active', 'canceled']
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
