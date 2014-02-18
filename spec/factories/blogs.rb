# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :blog do
    title "MyString"
    description "MyText"
    video_url "MyText"
    state false
    user_id 1
  end
end
