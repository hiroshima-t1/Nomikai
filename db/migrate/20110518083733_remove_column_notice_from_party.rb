class RemoveColumnNoticeFromParty < ActiveRecord::Migration
  def self.up
    remove_column :parties, :notice
  end

  def self.down
    add_column :parties, :notice
  end
end
