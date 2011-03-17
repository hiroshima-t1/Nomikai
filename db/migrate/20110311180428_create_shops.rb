class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :shop_id
      t.string :class_api
      t.string :shop_name
      t.text :adress
      t.string :phone_number
      t.text :picture
      t.string :upd_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
