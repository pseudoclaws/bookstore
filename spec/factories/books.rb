FactoryBot.define do
  factory :book do
    title FFaker::Book.unique.title
    publisher { create(:publisher) }
  end
end