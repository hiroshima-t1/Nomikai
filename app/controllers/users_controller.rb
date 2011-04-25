class UsersController < BaseController
  # Filters
  before_filter :login_required, :only => nil
  before_filter :login_required, :except => [:new, :create, :activate]
  before_filter :require_invitation, :only => [:new, :create]
  
  def require_invitation
    redirect_to login_path and return false unless params[:inviter_id] && params[:inviter_code]
    redirect_to login_path and return false unless User.find(params[:inviter_id]).valid_invite_code?(params[:inviter_code])
  end

  def show
    unless session[:original_uri].nil?
      uri = session[:original_uri]
      session[:original_uri] = nil
      redirect_to(uri || {:controller => :parties, :action => :index})
      return
    end

    redirect_to :controller => :parties, :action => :index
  end
end