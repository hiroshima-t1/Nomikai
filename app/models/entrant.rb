class Entrant < ActiveRecord::Base
  belongs_to :user, :foreign_key => "id"
  belongs_to :group, :foreign_key => "group_id"
end
