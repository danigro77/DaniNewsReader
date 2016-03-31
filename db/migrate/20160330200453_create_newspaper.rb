class CreateNewspaper < ActiveRecord::Migration
  def change
    create_table :newspapers do |t|
      t.string :name
      t.string :scraping_type
      t.string :url
      t.string :language

      t.timestamps
    end
  end
end
