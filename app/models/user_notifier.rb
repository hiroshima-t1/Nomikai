class UserNotifier < ActionMailer::Base
  
  def party_notification(user, party, shop)
    setup_sender_info
    @recipients  = "#{user.email}"
    @subject     = "飲み会開催通知"
    @sent_on     = Time.now
    @body[:user] = user
    @body[:party] = party
    @body[:shop] = shop
    @body[:party_date] = party.opendate.strftime("%Y年 %m月 %d日 %H時 %M分")
    @body[:shop_name] = shop.nil? ? "お店情報がありません" : shop.name
    @body[:shop_address] = shop.nil? ? "お店情報がありません" : shop.address
    @body[:shop_url] = shop.nil? ? "お店情報がありません" : shop.urls.pc
    @body[:class_party] =  party.class_party.nil? ? "" : "(#{party.class_party.class_party_name})"
    @body[:party_detail_url] = url_for :controller=>'party', :action=>'party_detail', :id=>party, :only_path => false
  end
end
