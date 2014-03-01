class Myaccount::OverviewsController < Myaccount::BaseController
  before_filter :check_user_role ,:only =>[:edit]
  def show

  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    
    if @user.update_attributes(user_params)
      if current_user
        if current_user.admin? || current_user.designer?
          redirect_to admin_path
        else
          redirect_to myaccount_overview_url(), :notice  => "Successfully updated user."
        end
      end
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit!#(:password, :password_confirmation, :first_name, :last_name,:phone,:images_attributes,:bday,:about_me)
    end
    def selected_myaccount_tab(tab)
      tab == 'profile'
    end
end
