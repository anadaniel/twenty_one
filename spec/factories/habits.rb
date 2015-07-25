FactoryGirl.define do
  factory :habit do
    title { FFaker::Lorem.word }
    partner_name { FFaker::Name.name }
    partner_email { FFaker::Internet.email }
    category "wellness"
    start_date { Date.yesterday }
    last_date { Date.today }
    active true
    user { FactoryGirl.create :user }
    
    factory :start_habit do
      goal_type "start"
    end

    factory :stop_habit do
      goal_type "stop"
    end
  end
end
