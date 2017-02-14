FactoryGirl.define do
  factory :reservation do
    property_id 1
    user_id 1
    checkin_date "2017-02-05"
    checkout_date "2017-02-05"
    status 1
  end
end
