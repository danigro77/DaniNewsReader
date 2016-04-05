FactoryGirl.define do
  factory :newspaper do
    name "The News"
    url "http://exampleNews.com" #this one is found: /factories/test_files/example_page.com and pulled through FakeWeh
    language "en"
    link_type "partial"
    link_characteristic "num_front"

    trait :with_full_url do
      link_type "full"
      link_characteristic "default"
    end

    trait :with_front_num do
      # for article with url "/2016/04/04/important-newsarticle"
      link_characteristic "num_front"
    end
    trait :with_end_num do
      # for article with url "/important-newsarticle/for-123455"
      link_characteristic "num_end"
    end

    factory :newspaper_partial_front, traits: [:with_front_num]
    factory :newspaper_partial_end, traits: [:with_end_num]
    factory :newspaper_full, traits: [:with_full_url]

    #  has many Articles
    #  create(:user_with_articles, article_count: 2)

    trait :with_articles do
      ignore do
        article_count 2
      end
      after(:create) do |newspaper, evaluator|
        url = case newspaper.link_type
                when "full"
                  "http://full-url.com/to-other-page"
                when "partial"
                  if newspaper.link_characteristic == "num_front"
                    "/2016/04/04/important-newsarticle"
                  else
                    "/important-newsarticle/for-123455"
                  end
              end
        create_list(:article, evaluator.article_count, newspaper: newspaper, url: url)
      end
    end

    factory :newspaper_with_articles, traits: [:with_articles]
    factory :newspaper_partial_with_articles, traits: [:with_articles, :with_end_num]

  end

end