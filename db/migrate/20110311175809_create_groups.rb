class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :group_id
      t.string :group_name
      t.text :comment
      t.string :upd_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
