class AddScrapingHelperToNewspaper < ActiveRecord::Migration
  def change
    remove_column :newspapers, :scraping_type
    add_column :newspapers, :link_type, :string
    add_column :newspapers, :link_characteristic, :string
  end
end
