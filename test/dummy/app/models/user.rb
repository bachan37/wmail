class User < ActiveRecord::Base

  attr_accessible :user_name

  validates :user_name, :presence => true, :uniqueness => { :case_sensitive => false }

  def self.authenticate_with_id(id)
    user = self.find_by_id(id)
    user.blank? ? nil : user
  end
end
