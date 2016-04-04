class Article < ActiveRecord::Base
  belongs_to :newspaper
  has_and_belongs_to_many :users

  validates_presence_of :title, :url, :newspaper_id
end