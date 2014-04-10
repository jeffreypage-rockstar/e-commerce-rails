require 'will_paginate/array'
class Myaccount::OverviewsController < Myaccount::BaseController
  before_filter :check_user_role ,:only =>[:edit]
  def show
    @news = News.where('state = ?',true)
    #@orders = current_user.orders.where('state = complete', :include => {:order_items => {:varients => :product}})
    @orders = Order.where("user_id = ? && state = 'complete'",current_user.id).includes({:order_items => :variant})
    
    #@products = Product.all
    @products = []

    @orders.each do |order|
        order.order_items.each_with_index do |item, i|
            unless @products.include?(item.variant.product)
              @products << item.variant.product
            end
            
        end

    end

    @products = @products.paginate(:page => pagination_page, :per_page => 8)
    @user = current_user
    @ratings = current_user.ratings
    if @ratings == []
      @rating = Rating.new(:id => 0,:score => 0)
    end
    #if current_user.designer?
    
    #    render :action => 'show_designer'
    #else
    #    render :action => 'show'
    #end
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
