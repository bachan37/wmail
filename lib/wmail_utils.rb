#---------------------------------------------------------------------------
# desc: It is the library for the IMAP initialization and related stuffs
# created at: 28/08/2012
#---------------------------------------------------------------------------

require 'net/imap'

module WmailUtils

  class WmailImapUtils
    attr_accessor :user_account, :connected

    def initialize(wmail_account)
      @user_account = wmail_account
      @connected = false
    end

    def imap_authenticate(wmail_account)
      
      unless @connected

        begin
          @imap = Net::IMAP.new(wmail_account.server, wmail_account.port, wmail_account.enable_ssl)

          #@imap = Net::IMAP.new('imap.mail.yahoo.com', 993, true)
          @imap.login(wmail_account.user_email, wmail_account.password)
          
          WmailImapUtils.connected = true
          WmailImapUtils.credentials=({:user_email => wmail_account.user_email, :user_password => wmail_account.password})
          WmailImapUtils.current_imap = @imap
        rescue Exception => e
          # here you can add code to customize it.
        end

      end

      @connected
    end

    def imap
      @imap
    end

    def self.current_imap=(imap_obj)
      @current_imap = imap_obj
    end

    def self.connected=(bool_connection)
      @connected = bool_connection
    end

    def self.current_imap
      @current_imap
    end

    def self.credentials=(wmail_account)
      @user_account = wmail_account
    end

    def self.credentials
      @user_account
    end

    def self.set_connection
      connection_flag = false

      if @connected
        unless @current_imap.blank?
          if @current_imap.disconnected?
            connection_flag = reconnect
          else
            connection_flag = true
          end
        else
          connection_flag = reconnect
        end
      else
        puts 'not connected'
        @current_imap.disconnect unless @current_imap.disconnected? unless @current_imap.blank?
      end

      return connection_flag
    end

    def self.get_mailbox_list

      if set_connection
        @current_imap.list("", "*")
      end

    end
    
    private

    def self.reconnect
      @connected = false
      wmutils = self.new(@user_account)
      flag = wmutils.imap_authenticate(@user_account)
      return flag
    end

  end

end

module Net
  class IMAP
    class ResponseParser
      def search_response # line 2706 imap.rb
      token = match(T_ATOM)
      name = token.value.upcase
      token = lookahead
      if token.symbol == T_SPACE
        shift_token
        data = []
        while true
          token = lookahead
    #begin patch  - yahoo IMAP was returning pattern " SEARCH 1 2 \r\n  so was doing push on CRLF
          case token.symbol
            when T_CRLF
              break
            when T_SPACE
              shift_token
            else
              data.push(number)
          end
    #end patch
        end
      else
        data = []
      end
      return UntaggedResponse.new(name, data, @str)
    end
    end #class ResponseParser
  end #class IMAP
end