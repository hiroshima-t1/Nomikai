class BaseController < ApplicationController
#  before_filter :login_required, :only => :site_index

  before_filter :login_check

  def site_index
    redirect_to :controller => :parties, :action => :index
  end

  def login_check
    if current_user.nil?
      session[:original_uri] = request.request_uri
      redirect_to :controller => :sessions, :action => :new
    end
  end
end
