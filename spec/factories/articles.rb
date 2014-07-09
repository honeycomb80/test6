# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    week_id 1
    month_id 1
    year_id 1
    date "2014-07-07"
    url "MyString"
    headline "MyString"
  end
end
