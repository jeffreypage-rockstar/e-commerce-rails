# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    user nil
    score 1
    default "MyString"
    0 "MyString"
  end
end
