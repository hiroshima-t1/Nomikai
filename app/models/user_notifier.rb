class UserNotifier < ActionMailer::Base
  
  def party_notification(email, user, message)
    setup_sender_info
    @recipients  = "#{email}"
    @subject     = "party notification"
    @sent_on     = Time.now
    @body[:user] = user
    @body[:message] = message
  end
end
