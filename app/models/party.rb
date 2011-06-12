class Party < ActiveRecord::Base
  has_many :members
  belongs_to :user
  belongs_to :class_party
#  belongs_to :shop

  CLASS_PARTY_TYPE = [
    ["飲み放題込",   "2"],
    ["ドリンク代込", "1"],
    ["ドリンク代別", "0"]
  ]

  PARTY_STATUS_TYPE = [
    ["未配信", "0"],
    ["開催",   "1"],
    ["中止",   "2"]
  ]

  # 飲み会参加者全員にメール送信
  def send_party_notification
    members = Member.find_all_by_party_id(self.id, :include => "user")
    res = HotPepper.find_shop_by_id(self.shop_id)
    shop = nil
    shop = res.shop if res.found?

    members.each do |member|
      ok = member.user != nil && member.user.email != nil
      ok &&= yield(member) if block_given?
      
      if ok
        UserNotifier.deliver_party_notification(member.user, self, shop)
      end
    end
  end

  def create_members_from_params(entrants)
    unless entrants.nil?
      entrants.each do |entrant|
        members << Member.create_from_entrant(id, entrant)
      end
      members.each do |member|
        member.destroy if entrants.index(member.user_id.to_s).nil?
      end
    end
  end

  def create_shop_from_params(params)
    unless params.nil?
      
    end
  end

  def self.attributes_from_params(params)
    if params[:id].nil?
      party = self.new
    else
      party = self.find(params[:id])
    end

    attributes = params[:party]
    attributes[:opendate] = Time.mktime(
                              params[:year],
                              params[:month],
                              params[:day],
                              params[:hour],
                              params[:minute],
                              0
                            ).strftime("%Y/%m/%d %H:%M:%S")
    party.attributes = attributes

    entrants = params[:entrants] || []
    party.create_members_from_params(params[:entrants])
#    party.create_shop_from_params(params[:shop])

    party
  end

protected
  def after_initialize
    self.party_status = '0' if self.party_status.nil?
    self.class_api = '1' if self.class_api.nil?
    self.plan_date = Time.new if self.plan_date.nil?
  end
end
