class HotPepper < ActiveResource::Base
  self.site = 'http://webservice.recruit.co.jp/'
  API_KEY = ""
  
  def self.find_shop(params = {})
    params[:key] = API_KEY unless params.has_key?(:key)
    self.find(:one, :from=>"/hotpepper/gourmet/v1/", :params=>params)
  end
  
  # 店idで検索
  def self.find_shop_by_id(id)
    find_shop(:id => id, :count => 1)
  end
  
  # 結果が複数件、1件、0件全て透過的に扱えるように
  def each_shop(&block)
    return unless found?
    
    if shop.respond_to?(:each)
      shop.each(&block)
    else
      block.call(shop) 
    end
  end
  
  def found?
    !error? && results_returned.to_i > 0
  end
  
  def error?
    attributes['error'] ? true : false
  end
  
  def error_message
    error? ? error.message : nil
  end
end
