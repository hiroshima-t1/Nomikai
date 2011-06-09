class BaseController < ApplicationController
#  before_filter :login_required, :only => :site_index

  before_filter :login_check

  def site_index
    redirect_to :controller => :parties, :action => :index
  end

  def login_check
    login_required
  end
end
