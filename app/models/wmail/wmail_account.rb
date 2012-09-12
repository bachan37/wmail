#------------------------------------------------------------
# desc: Model to handle the email accounts related to a user.
# created on: 22/08/2012
#------------------------------------------------------------

module Wmail
  class WmailAccount < ActiveRecord::Base
    attr_accessible :user_id, :user_email, :account_type, :server, :port, :enable_ssl

    belongs_to :user, :class_name => Wmail.user_class, :foreign_key => :user_id

    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :user_id, :presence => true

    # A user cannot have two accounts with same email. user_id+user_email should be unique.
    validates :user_email, :presence => true, :format => { :with => email_regex },
      :uniqueness => { :case_sensitive => false, :scope => :user_id }
  end
end