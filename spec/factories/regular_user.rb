FactoryBot.define do
 factory :regular_user, class: User do
   name     { "Meg" }
   street_address  { "123 Stang Ave" }
   city     { "Hershey" }
   state    { "PA" }
   zip      { "17033" }
   email   { "meg@example.com" }
   password { "123456" }
   password_confirmation { "123456" }
   role { 0 }
 end
end
