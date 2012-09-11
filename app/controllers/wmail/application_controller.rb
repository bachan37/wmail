require 'wmail_utils'

module Wmail
  class ApplicationController < ::ApplicationController
    include WmailUtils
    
    private

    #-------------------------------------------------------------------
    # desc: checking the imap object (nil, connected ot not etc.)
    #-------------------------------------------------------------------
    def check_imap
      puts WmailImapUtils.current_imap.to_s + '##############'
      puts WmailImapUtils.set_connection.to_s

      #redirect to login account if not connected
      if not WmailImapUtils.set_connection
        redirect_to login_wmail_accounts_path,
          :alert => 'Please login to your account'
      end
    end

  end
end
