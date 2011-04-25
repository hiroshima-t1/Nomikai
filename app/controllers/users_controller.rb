class UsersController < BaseController
  # Filters
  before_filter :login_required, :only => nil
  before_filter :login_required, :except => [:new, :create, :activate]
  before_filter :require_invitation, :only => [:new, :create]
  
  def require_invitation
    redirect_to login_path and return false unless params[:inviter_id] && params[:inviter_code]
    redirect_to login_path and return false unless User.find(params[:inviter_id]).valid_invite_code?(params[:inviter_code])
  end

<<<<<<< HEAD
  def update_account
    @user             = current_user
#    @user.attributes  = params[:user]
    
    puts @user.inspect

    if @user.update_attributes(params[:user])
      flash[:notice] = :your_changes_were_saved.l
      respond_to do |format|
        format.html {redirect_to user_path(@user)}
        format.js
      end      
    else
      respond_to do |format|
        format.html {render :action => 'edit_account'}
        format.js
      end
    end
=======
  def show
    unless session[:original_uri].nil?
      uri = session[:original_uri]
      session[:original_uri] = nil
      redirect_to(uri || {:controller => :parties, :action => :index})
      return
    end

    redirect_to :controller => :parties, :action => :index
>>>>>>> 2ef23adfbb4f91ae107e06a3520cab0b0c7315e3
  end
end