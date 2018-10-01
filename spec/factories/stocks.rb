FactoryBot.define do
  factory :stock do
    store { create(:store) }
    book { create(:book) }
    copies_in_stock { 0 }
  end
end