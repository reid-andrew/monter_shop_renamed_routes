FactoryBot.define do
 factory :merchant_user, class: User do
   name     { "Mike Dao" }
   street_address  { "1765 Larimer St" }
   city     { "Denver" }
   state    { "CO" }
   zip      { "80202" }
   email   { "mike@example.com" }
   password { "123456" }
   password_confirmation { "123456" }
   role { 1 }
   association :merchant, factory: :merchant
 end
end
