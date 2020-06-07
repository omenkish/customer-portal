FactoryBot.define do
  factory :ticket do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentences }
  end
end
