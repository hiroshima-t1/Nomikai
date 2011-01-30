class CommunityEngineToVersion73 < ActiveRecord::Migration
  def self.up
    migrate_plugin(:community_engine, 73)  
  end

  def self.down
    migrate_plugin(:community_engine, 0)    
  end
end
