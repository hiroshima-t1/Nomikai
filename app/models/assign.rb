class Assign < ActiveRecord::Base
  belongs_to :group, :foreign_key => "upd_user_id"
  belongs_to :user
end
