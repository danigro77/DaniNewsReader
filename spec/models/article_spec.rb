require 'rails_helper'

RSpec.describe Article, type: :model do

  let(:article) { create :article }
  let(:article_with_partial_front) { create :article_with_partial_front }
  let(:article_with_partial_end) { create :article_with_partial_end }

  # Validations
  # ===========
  it "has a valid factory" do
    expect( FactoryGirl.create(:article) ).to be_valid
    expect( FactoryGirl.create(:article_with_partial_front) ).to be_valid
    expect( FactoryGirl.create(:article_with_partial_end) ).to be_valid
  end
  it "is invalid without an title" do
    expect( FactoryGirl.build(:article, title: nil)).not_to be_valid
  end
  it "is invalid without a url" do
    expect( FactoryGirl.build(:article, url: nil)).not_to be_valid
  end
  it "is invalid without a newspaper_id" do
    expect( FactoryGirl.build(:article, newspaper_id: nil)).not_to be_valid
  end

  # Relations
  # =========
  describe "relations to other models" do
    it { should have_and_belong_to_many(:users) }
    it { should belong_to(:newspaper) }
  end
end
