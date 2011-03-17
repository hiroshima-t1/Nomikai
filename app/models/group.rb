class Group < ActiveRecord::Base
  has_many :assigns
  belongs_to :user, :foreign_key => "upd_user_id"
end
