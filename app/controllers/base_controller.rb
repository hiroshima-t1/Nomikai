class BaseController < ApplicationController
  before_filter :login_required, :only => :site_index
end