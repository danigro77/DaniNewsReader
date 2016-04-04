class Article < ActiveRecord::Base
  belongs_to :newspaper
  has_and_belongs_to_many :users

end