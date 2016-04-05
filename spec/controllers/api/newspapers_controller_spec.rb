require "rails_helper"

RSpec.describe Api::NewspapersController, :type => :api do
  let(:user) { FactoryGirl.create(:user_with_articles, article_count:10) }
  let(:newspaper) { user.current_newspaper }
  let(:another_newspaper) { FactoryGirl.create(:newspaper_partial_end) }
  let(:yet_another_newspaper) { FactoryGirl.create(:newspaper_full) }
  let!(:newspapers) { [newspaper, another_newspaper, yet_another_newspaper] }

  before :each do
    login(user)
  end

  after :each do
    logout
  end

  describe "GET api/newspapers/all" do
    it 'returns newspapers' do
      response = get "api/newspapers/all", format: :json

      json = JSON.parse(response.body)

      # test for the 200 status-code
      expect(response).to be_successful

      # check to make sure the right values are returned
      expect(json.length).to eq newspapers.length
      expect(json.first.class).to eq Hash
    end
  end

  describe "GET api/newspapers/current" do

    it "returns the user's last visited newspaper" do
      response = get "/api/newspapers/current", format: :json

      json = JSON.parse(response.body)

      # test for the 200 status-code
      expect(response).to be_successful

      # check to make sure the right values are returned
      expect(json['name']).to eq newspaper['name']
      expect(json['url']).to eq newspaper['url']
      expect(json['id']).to eq newspaper['id']
      expect(json['link_type']).to eq newspaper['link_type']
    end
  end

  describe "PUT api/newspapers/save_current/:newspaper_id" do

    it 'saves an article' do
      response = put "/api/newspapers/save_current/#{another_newspaper.id}", format: :json

      # test for the 200 status-code
      expect(response).to be_successful

      # check to make sure the right values are returned
      user.reload
      expect(user.current_newspaper).to eq another_newspaper
    end
  end
end