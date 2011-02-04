# This controller handles the login/logout function of the site.  
class SessionsController < BaseController
  layout "login"
  
  def destroy
    current_user_session.destroy
    flash[:notice] = :youve_been_logged_out_hope_you_come_back_soon.l
    redirect_to login_path
  end

end
