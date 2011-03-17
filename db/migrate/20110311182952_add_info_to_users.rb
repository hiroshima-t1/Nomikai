class AddInfoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_name_c, :string
    add_column :users, :user_name_k, :string
    add_column :users, :phone_number, :string
    add_column :users, :drink, :string
    add_column :users, :adress, :text
    add_column :users, :mail_adress, :text
    add_column :users, :upd_user_id, :string
  end

  def self.down
    remove_column :users, :user_name_k
    remove_column :users, :user_name_c
    remove_column :users, :phone_number
    remove_column :users, :drink
    remove_column :users, :adress
    remove_column :users, :mail_adress
    remove_column :users, :upd_user_id
  end
end
