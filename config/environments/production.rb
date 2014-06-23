Hadean::Application.configure do
  # Rails 4
  config.eager_load = true
  config.assets.js_compressor = :uglifier

  # Settings specified here will take precedence over those in config/environment.rb

  # config.force_ssl = true

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  #config.assets.precompile << '*.js'
  #config.assets.precompile << /(^[^_\/]|\/[^_])[^\/]*$/
  # Add the fonts path
  #config.assets.paths << "#{Rails.root}/app/assets/fonts"
 
  # Precompile additional assets
  config.assets.precompile += %w( .svg .eot .woff .ttf )
  config.assets.precompile += %w( '*.js','*/*.js','*/*/*.js' )
  config.assets.precompile += [ 'admin.js','blogs.js']
  config.assets.precompile += [ 'admin.css',
                                'admin/app.css',
                                'admin/cart.css',
                                'admin/foundation.css',
                                'admin/normalize.css',
                                'admin/help.css',
                                'admin/ie.css',
                                'autocomplete.css',
                                'application.css',
                                'chosen.css',
                                'foundation.css',
                                'foundation_and_overrides.css',
                                'home_page.css',
                                'ie.css',
                                'ie6.css',
                                'login.css',
                                'markdown.css',
                                'myaccount.css',
                                'normalize.css',
                                'pikachoose_product.css',
                                'product_page.css',
                                'products_page.css',
                                'shopping_cart_page.css',
                                'signup.css',
                                'site/app.css',
                                'sprite.css',
                                'tables.css',
                                'cupertino/jquery-ui-1.8.12.custom.css',# in vendor
                                'modstyles.css', # in vendor
                                'scaffold.css' # in vendor
                                ]
  config.assets.compile = [ Proc.new { |path| 
   !File.extname(path).in?(['.js', '.css', '']) 
  }, /(?:\/|\\|\A)application\.(css|js)$/ ]

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  

  if ENV['FOG_DIRECTORY'].present?
    # config.action_controller.asset_host = "https://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com"
  end

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files
  config.cache_store = :memory_store
  #config.cache_store = :dalli_store

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  config.action_mailer.default_url_options = { :host => 'ror-e.herokuapp.com' }
  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify


  config.after_initialize do
    #Formtastic::SemanticFormBuilder.send(:include, Formtastic::DatePicker)
    #Formtastic::SemanticFormBuilder.send(:include, Formtastic::FuturePicker)
    #Formtastic::SemanticFormBuilder.send(:include, Formtastic::YearPicker)

    ActiveMerchant::Billing::Base.mode = :test
    #::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
    #  :login      => Settings.paypal.login,
    #  :password   => Settings.paypal.password,
    #  :signature  => Settings.paypal.signature
    #)

    ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
  :login => "rordev.hb_api1.gmail.com",
  :password  => "1403273259",
  :signature => "Aqwyj4hreSm6jTjn1kZkRHQYe3jEANcebP9z9AEHXj14kWvnWFkixN3c"
)
    #Paperclip::Attachment.default_options[:storage] = :s3
    #::GATEWAY = ActiveMerchant::Billing::BraintreeGateway.new(
    #  :login     => Settings.braintree.login,
    #  :password  => Settings.braintree.password
    #)
  end
  PAPERCLIP_STORAGE_OPTS = {  :styles => {:mini => '48x48>',
                                          :small    => '100x100>',
                                          :medium   => '200x200>',
                                          :product  => '270x325>',
                                          :large    => '600x600>' },
                              :default_style => :product,
                              :url => "/assets/products/:id/:style/:basename.:extension",
                              :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension" }

  PAPERCLIP_STORAGE_OPTS_BANNER = {  :styles => {
                                          :small    => '100x100>',
                                          :large    => '600x600>' },
                                          :default_style => :large,
                                          :url => "/assets/banners/:id/:style/:basename.:extension",
                                          :path => ":rails_root/public/assets/banners/:id/:style/:basename.:extension" }
end
