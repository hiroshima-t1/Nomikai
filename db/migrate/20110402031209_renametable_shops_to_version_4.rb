class RenametableShopsToVersion4 < ActiveRecord::Migration
  def self.up
    drop_table :shops

    create_table :partyshops do |t|
      t.string :shop_id
      t.string :class_api
      t.string :shop_name
      t.text :address
      t.string :phone_number
      t.text :picture_s
      t.text :picture_m
      t.text :picture_l
      t.string :upd_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :partyshops
  end
end
