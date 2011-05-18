class AlterTablesDdlToVersion6 < ActiveRecord::Migration
  def self.up
    change_column :assigns, :group_id, :integer
    change_column :assigns, :user_id, :integer
    change_column :assigns, :upd_user_id, :integer
    change_column :class_parties, :upd_user_id, :integer
    change_column :groups, :group_id, :integer
    change_column :groups, :upd_user_id, :integer
    change_column :members, :user_id, :integer
    change_column :members, :upd_user_id, :integer
    change_column :parties, :user_id, :integer
    change_column :parties, :class_party_id, :integer
    change_column :parties, :upd_user_id, :integer
    change_column :partyshops, :upd_user_id, :integer
    change_column :users, :upd_user_id, :integer
    end
  end

  def self.down
    change_column :assigns, :group_id, :string
    change_column :assigns, :user_id, :string
    change_column :assigns, :upd_user_id, :string
    change_column :class_parties, :upd_user_id, :string
    change_column :groups, :group_id, :string
    change_column :groups, :upd_user_id, :string
    change_column :members, :user_id, :string
    change_column :members, :upd_user_id, :string
    change_column :parties, :user_id, :string
    change_column :parties, :class_party_id, :string
    change_column :parties, :upd_user_id, :string
    change_column :partyshops, :upd_user_id, :string
    change_column :users, :upd_user_id, :string
end
