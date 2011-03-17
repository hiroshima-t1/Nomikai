class CreateAssigns < ActiveRecord::Migration
  def self.up
    create_table :assigns do |t|
      t.string :group_id
      t.string :user_id
      t.string :upd_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :assigns
  end
end
