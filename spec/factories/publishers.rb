FactoryBot.define do
  factory :publisher do
    name FFaker::Company.unique.name
  end
end