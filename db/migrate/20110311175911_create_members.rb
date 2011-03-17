class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :user_id
      t.string :party_id
      t.string :member_status
      t.string :upd_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
