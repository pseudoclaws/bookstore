FactoryBot.define do
  factory :sale do
    publisher { create(:publisher) }
    store { create(:store) }
    books_sold_count { 0 }
  end
end