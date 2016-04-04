class AddCurrentNewspaperToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_newspaper_id, :integer
  end
end
