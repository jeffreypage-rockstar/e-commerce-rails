class Admin::BaseController < ApplicationController
  helper_method :recent_admin_users
  layout 'admin'
  include ApplicationHelper
  before_filter :verify_admin
  after_filter :set_en_lang
  # load_and_authorize_resource
  def current_ability
    @current_ability ||= AdminAbility.new(current_user)
  end

  def set_en_lang
    I18n.locale = "en"
  end

  def update_all_language(obj,allowed_params)
    I18n.locale = "cn"
    obj.update_attributes(allowed_params_cn)
    I18n.locale = "tcn"
    obj.update_attributes(allowed_params_tcn)
    I18n.locale = "en"
    obj.update_attributes(allowed_params)
  end

  private

  def allowed_params_cn
    params.require(:cn).permit!
  end

  def allowed_params_tcn
    params.require(:tcn).permit!
  end

  def recent_admin_users
    session[:recent_users] ||= []
  end

  def add_to_recent_user(user)
    session[:recent_users] ||= []
    if session[:recent_users].any?{|email, id| id == user.id }
      session[:recent_users].delete_if {|email, id| id == user.id}
    elsif session[:recent_users].size > 10
      session[:recent_users].pop
    end
    session[:recent_users].unshift( [user.email, user.id] )
  end


  def ssl_required?
    ssl_supported?
  end

  def verify_admin
    if (!current_user) || (!current_user.admin? && !current_user.designer?)  
      redirect_to root_url 
    end
  end

  def verify_super_admin
    if current_user && current_user.admin? && !current_user.super_admin?
      redirect_to admin_users_url
    elsif current_user && current_user.designer?
      redirect_to admin_users_url
    elsif !current_user || !current_user.admin?
      redirect_to root_url
    end
  end

end
