# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sub_order do
    order_id "MyString"
    suborder_id "MyString"
    number "MyString"
    ip_address "MyString"
    email "MyString"
    state "MyString"
    customer_id 1
    designer_id 1
    ship_address_id 1
    coupon_id 1
    active 1
    shipped 1
    shipments_count 1
    calculated_at "2014-03-05 15:09:09"
    completed_at "2014-03-05 15:09:09"
    credited_amount "9.99"
  end
end
