FactoryGirl.define do
  factory :article do
    title { Faker::Hacker.say_something_smart }
    url { Faker::Internet.url }
    newspaper { create(:newspaper_full) }

    trait :with_front_num_partial do
      url "/2016/04/04/important-newsarticle"
      newspaper { create(:newspaper_partial_front) }
    end
    trait :with_end_num_partial do
      url "/important-newsarticle/for-123455"
      newspaper { create(:newspaper_partial_end) }
    end

    factory :article_with_partial_front, traits: [:with_front_num_partial]
    factory :article_with_partial_end, traits: [:with_end_num_partial]

  end

end