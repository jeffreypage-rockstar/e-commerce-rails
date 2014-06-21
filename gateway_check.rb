require "rubygems"
require "active_merchant"

ActiveMerchant::Billing::Base.mode = :test

gateway = ActiveMerchant::Billing::PaypalGateway.new(
  :login => "rordev.hb_api1.gmail.com",
  :password  => "1403273259",
  :signature => "Aqwyj4hreSm6jTjn1kZkRHQYe3jEANcebP9z9AEHXj14kWvnWFkixN3c"
)

credit_card = ActiveMerchant::Billing::CreditCard.new(
  :type               => "visa",
  :number             => "4032039742910104",
  :verification_value => "123",
  :month              => 6,
  :year               => 2019,
  :first_name         => "Rordev",
  :last_name          => "Rordev"
)

if credit_card.valid?
  # or gateway.purchase to do both authorize and capture
  response = gateway.authorize(1000, credit_card, :ip => "127.0.0.1")
  if response.success?
    gateway.capture(1000, response.authorization)
    puts "Purchase complete!"
  else
    puts "Error: #{response.message}"
  end
else
  puts "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
end
