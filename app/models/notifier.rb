class Notifier < ActionMailer::Base
  layout 'email'
  default :from => "id.email003@gmail.com"

  # Simple Welcome mailer
  # => CUSTOMIZE FOR YOUR OWN APP
  #
  # @param [user] user that signed up
  # => user must respond to email_address_with_name and name
  def signup_notification(recipient_id)
    @recipient = User.find(recipient_id)

    #attachments['an-image.jp'] = File.read("an-image.jpg")
    #attachments['terms.pdf'] = {:content => generate_your_pdf_here() }

    mail(:to => @recipient.email_address_with_name,
         :subject => "New account information") do |format|
      format.text { render :text => "Welcome!  #{@recipient.name} go to #{customer_activation_url(:a => @recipient.perishable_token )}" }
      format.html { render :text => "<h1>Welcome</h1> #{@recipient.name} <a href='#{customer_activation_url(:a => @recipient.perishable_token )}'>Click to Activate</a>" }
    end

  end

  def password_reset_instructions(user_id)
    @user = User.find(user_id)
    @url  = edit_customer_password_reset_url(:id => @user.perishable_token)
    @key  = UsersNewsletter.unsubscribe_key(@user.email)
    mail(:to => @user.email,
         :subject => "Reset Password Instructions")
  end

  def new_referral_credits(referring_user_id, referral_user_id)
    @user = User.find(referring_user_id)
    @key  = UsersNewsletter.unsubscribe_key(@user.email)
    @referral_user = User.find(referral_user_id)
    @url      = root_url
    @phone_number   = phone_number
    @company_name   = company_name

    mail(:to => @user.email,
         :subject => "Referral Credits have been Applied")
  end

  def order_confirmation(order_id, invoice_id)
    @invoice  = Invoice.find(invoice_id)
    @order    = Order.includes(:user).find(order_id)
    @user     = @order.user
    @key      = UsersNewsletter.unsubscribe_key(@user.email)
    @url      = root_url
    @site_name = 'site_name'
    mail(:to => @order.email,
         :subject => "Order Confirmation")
  end

  def referral_invite(referral_id, inviter_id)
    @user     = User.find(inviter_id)
    @referral = Referral.find(referral_id)
    @url      = root_url

    mail(:to => @referral.email,
         :subject => "Referral from #{@user.name}")
  end

  private
    def phone_number
      @phone_number   = I18n.t(:company_phone)
    end
    def company_name
      @company_name   = I18n.t(:company)
    end

end
