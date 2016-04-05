require "rails_helper"

RSpec.describe ReaderController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET #home" do

    before do
      sign_in(:user)
    end

    it "responds successfully with an HTTP 200 status code" do
      get :home
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :home
      expect(response).to render_template("home")
    end
  end
end