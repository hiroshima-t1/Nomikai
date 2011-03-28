class Party < ActiveRecord::Base
  has_many :members
  belongs_to :user
  belongs_to :class_party, :foreign_key => "class_party"

  CLASS_PARTY_TYPE = [
    ["飲み放題込",   "2"],
    ["ドリンク代込", "1"],
    ["ドリンク代別", "0"]
  ]

  # 飲み会参加者全員にメール送信
  def send_party_notification
  	members = Member.find_all_by_party_id(self.id)
  	members.each do |member|
      ok = member.user != nil && member.user.email != nil
      ok &&= yield(member) if block_given?
      
      if ok
        UserNotifier.deliver_party_notification(member.user.email, member.user, self.notice)
      end
    end
  end 
end
