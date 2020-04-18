FactoryBot.define do
  factory :discount, class: Discount do
    discount  { 5 }
    items     { 5 }
    active   { true }
    association :merchant, factory: :merchant  end
end
