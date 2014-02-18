# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :static_page do
    eng_title "MyString"
    t_chines_title "MyString"
    s_chines_title "MyString"
    eng_content "MyString"
    t_chines_content "MyString"
    s_chines_content "MyString"
    code "MyString"
    state false
  end
end
