class ClassParty < ActiveRecord::Base
  has_many :parties, :foreign_key => "class_party"
end
