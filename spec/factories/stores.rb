FactoryBot.define do
  factory :store do
    name FFaker::Company.unique.name
  end
end