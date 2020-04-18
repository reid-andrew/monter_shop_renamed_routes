FactoryBot.define do
  factory :merchant, class: Merchant do
    name     { "Brian's Bike Shop" }
    address  { "123 Bike Rd." }
    city     { "Richmond" }
    state    { "VA" }
    zip      { 23137 }
    active   { true }

  end
end
