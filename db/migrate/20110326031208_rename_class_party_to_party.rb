class RenameClassPartyToParty < ActiveRecord::Migration
  def self.up
    rename_column :parties, :class_party, :class_party_id
  end

  def self.down
    rename_column :parties, :class_party_id, :class_party
  end
end
