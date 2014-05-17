
# This is needed for using sendgrid on heroku

ActionMailer::Base.smtp_settings = {  
      :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'gmail.com',
    :user_name            => 'hiddenror@gmail.com',
    :password             => 'hb@hbdev',
    :authentication       => 'plain', 
      :enable_starttls_auto => true
}
ActionMailer::Base.delivery_method ||= :smtp
