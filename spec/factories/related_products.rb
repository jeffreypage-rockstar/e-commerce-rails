# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :related_product, :class => 'RelatedProducts' do
    product_id 1
    related_product_id 1
  end
end
