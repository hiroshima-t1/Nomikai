class Member < ActiveRecord::Base
  belongs_to :party

  PARTICIPATES = [
    "mikaitou.png",
    "sanka.png",
    "fusanka.png"
  ]

end
