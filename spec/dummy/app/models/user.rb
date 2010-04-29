class User < ActiveRecord::Base
  acts_as_authorized_user
  
  belongs_to :group, :class_name => "Group", :foreign_key => "member_id"
  
  def dogooder?
    true
  end
  
  def doeviler?
    false
  end
  
  def returns_symbol?
    :symbol
  end
  
  def returns_nil?
    nil
  end
end
