FactoryBot.define do
 factory :user_admin, class: User do
   name     { "Cory W" }
   street_address  { "1765 Larimer St" }
   city     { "Denver" }
   state    { "CO" }
   zip      { "80202" }
   email   { "cory@example.com" }
   password { "123456" }
   password_confirmation { "123456" }
   role { 2 }
   association :merchant, factory: :merchant
 end
end
