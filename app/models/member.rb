class Member < ActiveRecord::Base
  belongs_to :party
  belongs_to :user

  PARTICIPATES = [
    "mikaitou.png",
    "sanka.png",
    "fusanka.png",
    "tyushi.png"
  ]

  PARTICIPATES_TYPE = [
    "未回答",
    "参加",
    "不参加"
  ]

  def self.create_from_assign(party_id, assign)
    self.find(:first, :conditions => {:party_id => party_id.to_s, :user_id => assign.to_s}) ||
      self.new({:party_id => party_id, :user_id => assign.to_s})
  end

protected
  def after_initialize
    self.member_status = '0' if self.member_status.nil?
  end
end
