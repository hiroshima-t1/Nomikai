class CreateEntrantsToVersion7 < ActiveRecord::Migration
  def self.up
    create_table :entrants do |t|
      t.integer :group_id
      t.integer :user_id
      t.integer :upd_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :entrants
  end
end
