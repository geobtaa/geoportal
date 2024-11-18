FactoryBot.define do
  factory :geoname do
    geonameid { "" }
    name { "MyString" }
    asciiname { "MyString" }
    alternatenames { "MyText" }
    latitude { "9.99" }
    longitude { "9.99" }
    feature_class { "MyString" }
    feature_code { "MyString" }
    country_code { "MyString" }
    cc2 { "MyString" }
    admin1_code { "MyString" }
    admin2_code { "MyString" }
    admin3_code { "MyString" }
    admin4_code { "MyString" }
    population { "" }
    elevation { 1 }
    dem { 1 }
    timezone { "MyString" }
    modification_date { "2024-11-10" }
  end
end
