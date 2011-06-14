class User < ActiveRecord::Base
  has_many :parties
  has_many :members
  has_many :groups, :foreign_key => 'upd_user_id'

  # 表示名取得
  def display_name
    return user_name_c if !user_name_c.blank?
    return user_name_k if !user_name_k.blank?
    login
  end
  
  def display_gender
    return "" if gender.blank?
    return '男' if gender == "M"
    return '女' if gender == "F"
    ""
  end
end
