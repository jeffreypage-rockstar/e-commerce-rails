require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(:default, Rails.env) if defined?(Bundler)
# Bundler.require *Rails.groups(:assets => %w(development test)) if defined?(Bundler)
Bundler.require(:default, Rails.env)

module Hadean
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '0.11.0'

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/app/models/ror_e_reports)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # "Pacific Time (US & Canada)"
    # 'Central Time (US & Canada)'
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    I18n.enforce_available_locales = false

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure generators values
    config.generators do |g|
      g.test_framework  :rspec, :fixture => true
      g.fixture_replacement :factory_girl , :dir=>"spec/factories"
    end

    #config.session_store = ::Ripple::SessionStore

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password,
                                  :password_confirmation,
                                  :number,
                                  :cc_number,
                                  :cc_type,
                                  :brand,
                                  :card_number,
                                  :verification_value]
    # access any Settings here
    config.after_initialize do

      Paperclip::Attachment.default_options[:s3_protocol]     = Settings.paperclip.s3_protocol
      Paperclip::Attachment.default_options[:s3_credentials]  = Settings.paperclip.s3_credentials.to_hash
      Paperclip::Attachment.default_options[:bucket]          = Settings.paperclip.bucket
      Paperclip::Attachment.default_options[:hash_secret]     = Settings.paperclip.hash_secret

    end

    config.assets.paths << "#{Rails.root}/app/assets/font"

    config.action_mailer.default_url_options = {:host => "192.168.36.231:3002"}
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'gmail.com',
    :user_name            => 'hiddenror@gmail.com',
    :password             => 'hb@hbdev',
    :authentication       => 'plain',   
    :enable_starttls_auto => true  }
  end
end
