require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create :user }
  let(:user_with_articles) { create :user_with_articles }

  # Validations
  # ===========
  it "has a valid factory" do
    expect( FactoryGirl.create(:user) ).to be_valid
    expect( FactoryGirl.create(:user_with_articles) ).to be_valid
  end
  it "is invalid without an email" do
    expect( FactoryGirl.build(:user, email: nil)).not_to be_valid
  end
  it "is invalid without a password" do
    expect( FactoryGirl.build(:user, password: nil)).not_to be_valid
  end

  # Relations
  # =========
  describe "relations to other models" do
    it { should have_and_belong_to_many(:articles) }
    it { should belong_to(:current_newspaper) }
  end
end
