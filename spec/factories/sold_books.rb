FactoryBot.define do
  factory :sold_book do
    book { create(:book) }
    sale { create(:sale) }
    books_sold_count { 0 }
  end
end