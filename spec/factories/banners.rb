# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :banner do
    title "MyString"
    description "MyText"
    state false
  end
end
