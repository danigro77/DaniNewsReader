class AddNewspaperToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :newspaper_id, :integer
  end
end
