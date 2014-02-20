OmniAuth.config.logger = Rails.logger
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "1377312692524865", "25801c954fef812a3d552d509e90bc8a" , scope: 'email,user_birthday,read_stream'
end