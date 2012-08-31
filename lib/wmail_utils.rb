#---------------------------------------------------------------------------
# desc: It is the library for the IMAP initialization and related stuffs
# created at: 28/08/2012
#---------------------------------------------------------------------------

require 'net/imap'

module WmailUtils

  class WmailImapUtils
    attr_accessor :user_email, :user_password, :connected

    def initialize(options)
      @user_email = options[:user_email] ||= nil
      @user_password = options[:user_password] ||= nil
      @connected = false
    end

    def imap_authenticate(email, password)
      
      unless @connected

        begin
          @imap = Net::IMAP.new('imap.gmail.com', 993, true)
          @imap.login(email, password)
          @connected = true
          @current_imap = @imap
        rescue Exception => e
          # here you can add code to customize it.
        end

      end

      @connected
    end

    def imap
      @imap
    end

    def self.current_imap
      @current_imap
    end

    def self.is_connected?
      connection_flag = false
      connection_flag = !@current_imap.disconnected? unless @current_imap.blank? unless @connected
      return connection_flag
    end

    def self.reconnect
      self.new(:user_email => @user_email, :user_password => @user_password).imap_authenticate(@user_email, @user_password)
    end

  end

end