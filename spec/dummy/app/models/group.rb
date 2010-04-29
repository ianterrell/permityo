class Group < ActiveRecord::Base
  acts_as_authorizable
  
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  has_many :members, :class_name => "User", :foreign_key => "group_id"
end
