# This controller handles the login/logout function of the site.  
class SessionsController < BaseController
  layout "login"
  skip_before_filter :login_check

  def create
    @user_session = UserSession.new(:login => params[:login], :password => params[:password], :remember_me => params[:remember_me])

    if @user_session.save

      current_user = @user_session.record #if current_user has been called before this, it will ne nil, so we have to make to reset it
      
      flash[:notice] = :thanks_youre_now_logged_in.l
      redirect_back_or_default("/parties")
    else
      flash[:notice] = :uh_oh_we_couldnt_log_you_in_with_the_username_and_password_you_entered_try_again.l
      redirect_to teaser_path and return if AppConfig.closed_beta_mode        
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = :youve_been_logged_out_hope_you_come_back_soon.l
    redirect_to login_path
  end

end
