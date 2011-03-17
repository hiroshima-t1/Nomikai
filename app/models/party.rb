class Party < ActiveRecord::Base
  has_many :members
  belongs_to :user
  belongs_to :class_party, :foreign_key => "class_party"

  CLASS_PARTY_TYPE = [
    ["飲み放題込",   "2"],
    ["ドリンク代込", "1"],
    ["ドリンク代別", "0"]
  ]

end
