class AddRowsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_name, :string

    add_column :users, :location, :string

    add_column :users, :fb_url, :string

  end
end
