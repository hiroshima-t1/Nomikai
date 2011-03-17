class CreateClassParties < ActiveRecord::Migration
  def self.up
    create_table :class_parties do |t|
      t.string :class_party_name
      t.string :upd_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :class_parties
  end
end
