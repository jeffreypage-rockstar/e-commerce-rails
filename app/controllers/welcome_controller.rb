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
    @banners= Banner.active.order('created_at DESC').where("place = 'main_slide'")
    @banner_main_small = Banner.active.order('created_at DESC').where("place = 'main_small'")
    @super_hot_proudcts = Product.super_hot.aactive.limit(4)
    @featured_proudcts = Product.featured_products.aactive.limit(4)
    @new_products = Product.new_arrivals.aactive.limit(4)
    @news = News.where('state = ?',true)
    # @all_discounts = Variant.where(["discount_percent != '' "])
    @discount_fifties = Variant.where(["discount_percent = 50"]).limit(4)
    @discount_thirties = Variant.where(["discount_percent = 30"]).limit(4)
    @latest_blogs = Blog.order("created_at").limit(5).limit(4)
    @role = Role.find_by_name("designer")
    @featured_designers = @role.users.where(["featrued = ?",true]).limit(4)
    #@featured_designers =[]
  end

  def change_lang    
    if params[:new_locale] == "cn" || params[:new_locale] == "tcn"       
        session[:lang] = params[:new_locale]
        I18n.locale = session[:lang]
    else
        session[:lang] = "en"
        I18n.locale = session[:lang]
    end
    session[:place] = params[:place] if params[:place].present?
    if session[:previous_url].present?      
      if (session[:previous_url] =~ /new_locale/i) != nil
        redirect_to root_path    
      else
        redirect_to session[:previous_url]    
      end
    else
      redirect_to root_path
    end
  end

end
