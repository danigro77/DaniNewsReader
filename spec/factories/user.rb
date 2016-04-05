FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    current_newspaper { create(:newspaper) }

    #  has many Articles
    #  create(:user_with_articles, article_count: 2)

    trait :with_articles do
      ignore do
        article_count 2
      end
      after(:create) do |user, evaluator|
        evaluator.article_count.times do
          user.articles << create(:article, newspaper: user.current_newspaper)
          user.save
        end
      end
    end

    factory :user_with_articles, traits: [:with_articles]

  end

end