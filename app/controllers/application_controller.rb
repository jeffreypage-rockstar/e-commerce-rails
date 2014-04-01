class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  helper_method :current_user,
                :current_user_id,
                :most_likely_user,
                :random_user,
                :session_cart,
                :is_production_simulation,
                :search_product,
                :product_types,
                :myaccount_tab,
                :select_countries,
                :customer_confirmation_page_view

  before_filter :secure_session ,:check_user_session , :default_lang

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    if current_user && current_user.admin?
      flash[:alert] = 'Sorry you are not allowed to do that.'
      redirect_to :back
    else
      flash[:alert] = 'Sorry you are not allowed to do that.'
      redirect_to root_url
    end
  end


  def default_lang    
    #loading enitre language data into an object,to use in all views     
    
    flash = nil          
    # new_locale will carry language value,in its absence getting language from location or browser request
    if !params[:new_locale].present?      
        @country = Country.find_by_name(request.location.country) if request.location.present? && request.subdomain != "admin"
        #session[:lang] ||= @country.language if @country.present?        
        session[:lang] ||= ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/])      
        session[:lang] = "en" unless ["en","cn","tcn",:en,:cn,:tcn].include?(session[:lang])                          
        I18n.locale = session[:lang]
    else
      if params[:new_locale] == "tcn" || params[:new_locale] == "cn"       
        session[:lang] = params[:new_locale]        
      else
        session[:lang] = "en"
      end
      I18n.locale = session[:lang]
      session[:place] = params[:place] if params[:place].present?
    end
    # Fetching meta data from admin side
    # @general_setting=GeneralSetting.first
    # if @general_setting.present?      
    #   @meta_title = @general_setting.meta_title if @general_setting.meta_title.present?       
    #   @meta_keyword = @general_setting.meta_keyword if @general_setting.meta_keyword.present?
    #   @meta_desc=@general_setting.meta_description if @general_setting.meta_description.present?  
    # end
  end

  rescue_from ActiveRecord::DeleteRestrictionError do |exception|
    redirect_to :back, alert: exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def product_types
    @product_types ||= ProductType.roots
  end

  def check_user_session
    unless current_user
      @user_session = UserSession.new
      @user = User.new
    end
    if session_cart
      @cart_items       = session_cart.shopping_cart_items
      @saved_cart_items = session_cart.saved_cart_items
    end
    @brands = Brand.all.in_groups_of(6)
    @product_category_on_main_menu = ProductType.find_all_by_main_menu(true)
  end

  private



  def customer_confirmation_page_view
    false
  end

  def pagination_page
    params[:page] ||= 1
    params[:page].to_i
  end

  def pagination_rows
    params[:rows] ||= 25
    params[:rows].to_i
  end

  def myaccount_tab
    false
  end

  def require_user
    redirect_to login_url and store_return_location and return if logged_out?
  end

  def store_return_location
    # disallow return to login, logout, signup pages
    disallowed_urls = [ login_url, logout_url ]
    disallowed_urls.map!{|url| url[/\/\w+$/]}
    unless disallowed_urls.include?(request.url)
      session[:return_to] = request.url
    end
  end

  def logged_out?
    !current_user
  end

  def search_product
    @search_product || Product.new
  end

  def is_production_simulation
    false
  end

  def secure_session
    if Rails.env == 'production' || is_production_simulation
      if session_cart && !request.ssl?
        cookies[:insecure] = true
      else
        cookies[:insecure] = false
      end
    else
      cookies[:insecure] = false
    end
  end

  def session_cart
    return @session_cart if defined?(@session_cart)
    session_cart!
  end
  # use this method if you want to force a SQL query to get the cart.
  def session_cart!
    if cookies[:cart_id]
      @session_cart = Cart.includes(:shopping_cart_items).find_by_id(cookies[:cart_id])
      unless @session_cart
        @session_cart = Cart.create(:user_id => current_user_id)
        cookies[:cart_id] = @session_cart.id
      end
    elsif current_user && current_user.current_cart
      @session_cart = current_user.current_cart
      cookies[:cart_id] = @session_cart.id
    else
      @session_cart = Cart.create
      cookies[:cart_id] = @session_cart.id
    end
    @session_cart
  end
  ## The most likely user can be determined off the session / cookies or for now lets grab a random user
  #   Change this method for showing products that the end user will more than likely like.
  #
  def most_likely_user
    current_user ? current_user : random_user
  end

  ## TODO cookie[:hadean_user_id] value needs to be encrypted ### Authlogic persistence_token might work here
  def random_user
    return @random_user if defined?(@random_user)
    @random_user = cookies[:hadean_uid] ? User.find_by_persistence_token(cookies[:hadean_uid]) : nil
  end

  ###  Authlogic helper methods
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else  
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
  end

  def current_user_id
    return @current_user_id if defined?(@current_user_id)
    @current_user_id = current_user_session && current_user_session.record && current_user_session.record.id
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def select_countries
    @select_countries ||= Country.form_selector
  end

  def cc_params
    {
          :brand              => params[:type],
          :number             => params[:number],
          :verification_value => params[:verification_value],
          :month              => params[:month],
          :year               => params[:year],
          :first_name         => params[:first_name],
          :last_name          => params[:last_name]
    }
  end

  def expire_all_browser_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end


  # def current_user
  #   if @current_user
  #     @current_user = current_user
  #   elsif  session[:user_id]
  #     @current_user ||= User.find(session[:user_id]) if session[:user_id]
  #   end
  # end
  # helper_method :current_user

end
