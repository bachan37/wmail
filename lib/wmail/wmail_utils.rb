#---------------------------------------------------------------------------
# desc: It is the library for the IMAP initialization and related stuffs
# created at: 28/08/2012
#---------------------------------------------------------------------------

require 'net/imap'

module Wmail

  class WmailUtils
    attr_accessor :user_email, :user_password, :connected

    def initialize(options)
      @user_email = options[:user_email] ||= nil
      @user_password = options[:user_password] ||= nil
      @connected = false
    end

    def imap_authenticate(email, password)
      
      unless @connected
        @imap = Net::IMAP.new('imap.gmail.com', 993, true)
        @imap.login(email, password)
        @connected = true
      end
      
    end

    def imap
      @imap
    end

  end

end