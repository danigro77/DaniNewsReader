require "rails_helper"

RSpec.describe Api::ArticlesController, :type => :api do
  let(:user) { FactoryGirl.create(:user_with_articles, article_count:10) }
  let(:newspaper) { user.current_newspaper }
  let(:articles) { newspaper.articles }
  let!(:num_articles) {articles.length}

  before :each do
    login(user)
  end

  after :each do
    logout
  end

  describe "GET api/articles/all/:newspaper_id" do
    it 'returns all saved articles for a user and a newspaper' do
      response = get "/api/articles/all/#{newspaper.id}", format: :json

      json = JSON.parse(response.body)

      # test for the 200 status-code
      expect(response).to be_successful

      # check to make sure the right values are returned
      date = articles.first.created_at.localtime.beginning_of_day.strftime("%d %^b %Y")
      expect(json['saved'][date].length).to eq num_articles
      expect(json['saved'].keys.first).to eq date
      expect(json['existing_urls'].length).to eq num_articles
    end
  end

  describe "GET api/articles/headlines/:newspaper_id" do
    before do
      stream = File.read(File.dirname(__FILE__) +  "/test_files/example_page.html")
      FakeWeb.register_uri(:get,
                           "http://exampleNews.com",
                           :body => stream,
                           :content_type => "text/html")
    end

    it 'returns all headlines of the frontpage' do
      response = get "/api/articles/headlines/#{newspaper.id}", format: :json

      json = JSON.parse(response.body)

      # test for the 200 status-code
      expect(response).to be_successful

      # check to make sure the right values are returned
      regex = Newspaper::SCRAPE_HELPER[newspaper.link_type.to_sym][newspaper.link_characteristic.to_sym]
      expect(json.length).to eq 2
      json.each do |j|
        expect(j.keys).to eq %w(title url newspaper_id)
        expect(j['title']).to eq 'valid'
        expect(j['url']).to match regex
        expect(j['newspaper_id']).to eq newspaper.id
      end
    end
  end

  describe "POST api/articles/save_article" do

    let(:article) {{title: "Test article", url: "/123/33/test-partial", newspaper_id: newspaper.id} }

    it 'saves an article' do
      response = post "/api/articles/save_article", article: article, format: :json

      json = JSON.parse(response.body)

      # test for the 200 status-code
      expect(response).to be_successful

      # check to make sure the right values are returned
      date = articles.first.created_at.localtime.beginning_of_day.strftime("%d %^b %Y")
      expect(json['saved'][date].length).to eq num_articles+1
      expect(json['existing_urls'].length).to eq num_articles+1
    end
  end

  describe "DELETE api/articles/delete/:id" do

    let(:article) { articles.sample }

    it 'saves an article' do
      response = delete "/api/articles/delete/#{article.id}", format: :json

      # json = JSON.parse(response.body)

      # test for the 200 status-code
      expect(response).to be_successful

      # check to make sure the right values are returned
      newspaper.reload
      expect(newspaper.articles.length).to eq num_articles - 1
    end
  end
end