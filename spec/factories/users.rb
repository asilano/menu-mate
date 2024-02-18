FactoryBot.define do
  factory :user do
    google_userid { "987" }
    email { "astarion@vampire.com" }
    name { "Astarion Ancunin"}
    first_name { "Astarion" }
    picture_uri { "picture.pic/elf.jpg" }
  end
end
