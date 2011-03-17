class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.string :party_name
      t.string :party_status
      t.string :user_id
      t.text :notice
      t.string :shop_id
      t.string :class_api
      t.timestamp :opendate
      t.timestamp :plan_date
      t.integer :due
      t.string :class_party
      t.string :upd_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :parties
  end
end
