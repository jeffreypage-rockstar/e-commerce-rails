class OauthController < ApplicationController

  layout 'application'

  def redirect
  session[:access_token] = Koala::Facebook::OAuth.new(oauth_redirect_url).get_access_token(params[:code]) if params[:code]

  redirect_to session[:access_token] ? "http://www.facebook.com/hiddenbrains" : root_path
end

end
