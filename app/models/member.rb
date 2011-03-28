class Member < ActiveRecord::Base
  belongs_to :party
  belongs_to :user

  PARTICIPATES = [
    "mikaitou.png",
    "sanka.png",
    "fusanka.png"
  ]

end
