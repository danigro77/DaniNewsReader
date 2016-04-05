require 'rails_helper'

RSpec.describe Newspaper, type: :model do

  let(:newspaper_partial_front) { FactoryGirl.create :newspaper_partial_front }
  let(:newspaper_partial_end) { FactoryGirl.create :newspaper_partial_end }
  let(:newspaper_full) { FactoryGirl.create :newspaper_full }

  # Validations
  # ===========
  it "has a valid factory" do
    expect( FactoryGirl.create(:newspaper) ).to be_valid
    expect( FactoryGirl.create(:newspaper_partial_front) ).to be_valid
    expect( FactoryGirl.create(:newspaper_partial_end) ).to be_valid
    expect( FactoryGirl.create(:newspaper_full) ).to be_valid
  end
  it "is invalid without an url" do
    expect( FactoryGirl.build(:newspaper, url: nil)).not_to be_valid
  end
  it "is invalid without a name" do
    expect( FactoryGirl.build(:newspaper, name: nil)).not_to be_valid
  end
  it "is invalid without a link_type" do
    expect( FactoryGirl.build(:newspaper, link_type: nil)).not_to be_valid
  end

  context "link_type" do
    it "is valid when known" do
      Newspaper::KNOWN_LINK_TYPES.each do |type|
        expect( FactoryGirl.build(:newspaper, link_type: type)).to be_valid
      end
    end
    it "is not valid when unknown" do
      ['bla', "bla123", ""].each do |type|
        expect( FactoryGirl.build(:newspaper, link_type: type)).not_to be_valid
      end
    end
  end

  context "link_characteristic" do
    it "is valid when known" do
      Newspaper::KNOWN_CHARACTERISITCS.each do |char|
        expect( FactoryGirl.build(:newspaper, link_characteristic: char)).to be_valid
      end
    end
    it "is valid when nil" do
      expect( FactoryGirl.build(:newspaper, link_characteristic: nil)).to be_valid
    end
    it "is not valid when unknown" do
      ['bla', "bla123", ""].each do |char|
        expect( FactoryGirl.build(:newspaper, link_characteristic: char)).not_to be_valid
      end
    end
  end

  # Relations
  # =========
  describe "relations to other models" do
    it { should have_many(:articles) }
  end

  # Filter
  # ======

  describe "#check_url filter" do
    let(:url_with_dash) { "http://dasIstWas.de/" }
    let(:newspaper) { FactoryGirl.create(:newspaper, url: url_with_dash) }

    it "should alter the url" do
      expect( newspaper.url ).not_to eq url_with_dash
    end

  end

  # Methods
  # =======

  describe "#scrape_page" do

    before do
      stream = File.read(File.dirname(__FILE__) +  "/test_files/example_page.html")
      FakeWeb.register_uri(:get,
                           "http://exampleNews.com",
                           :body => stream,
                           :content_type => "text/html")
    end

    it "only look for saved patterns" do
      expect( newspaper_partial_front.scrape_page.length ).to eq 2
      expect( newspaper_partial_end.scrape_page.length ).to eq 3
      expect( newspaper_full.scrape_page.length ).to eq 4
    end

    it "ignores basic onside navigation" do
      %w(News Jobs Home).each do |nav_title|
        expect( newspaper_partial_front.scrape_page.map {|a| a[:title]} ).not_to include nav_title
        expect( newspaper_partial_end.scrape_page.map {|a| a[:title]} ).not_to include nav_title
        expect( newspaper_full.scrape_page.map {|a| a[:title]} ).not_to include nav_title
      end
    end

    it "returns unique values" do
      expect( newspaper_full.scrape_page.class ).to eq Array
      expect( newspaper_full.scrape_page.last.class ).to eq Hash
    end

    it "returns the longer title for the article" do
      expect( newspaper_full.scrape_page.last[:title] ).not_to eq "valid"
      expect( newspaper_full.scrape_page.last[:title] ).to eq "valid: longer test, same url"
    end

    it "does not return articles without a title" do
      expect( newspaper_full.scrape_page.last[:title] ).not_to eq ''
      expect( newspaper_full.scrape_page.last[:title] ).not_to be_nil
    end
  end

end
