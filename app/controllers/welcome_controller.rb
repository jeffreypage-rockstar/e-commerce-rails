class WelcomeController < ApplicationController

  layout 'application'

  def index
    type = params[:option].present? ? params[:option] : ""
    @featured_product = Product.featured
    @best_selling_products = Product.limit(5)
    if type == "brand"
      @brands = Brand.all
    elsif type == "style"
    end
    @role = Role.find_by_name("designer")
    @designers = @role.users
    @other_products  ## search 2 or 3 categories (maybe based on the user)
    unless @featured_product
      if current_user && current_user.admin?
        redirect_to admin_merchandise_products_url
      else
        redirect_to login_url
      end
    end
  end

  def static_page
    @static_page = StaticPage.find_by_code(params[:code])
  end

  def welcome
    type = params[:option].present? ? params[:option] : ""
    @featured_product = Product.featured
    @best_selling_products = Product.limit(5)
    if type == "brand"
      @brands = Brand.all
    elsif type == "style"
    end
    @role = Role.find_by_name("designer")
    @designers = @role.users
    @other_products  ## search 2 or 3 categories (maybe based on the user)
    render :layout=>"home"
    
  end


end
