class AddIsLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_login, :boolean
  end
end
