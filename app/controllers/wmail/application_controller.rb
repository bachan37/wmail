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
        redirect_to authenticate_wmail_accounts_path(:redirect => params),
          :alert => 'Please login to your account'
      end
    end

    #-------------------------------------------------------------------
    # desc: fetch the labels/folders of the mailbox
    #-------------------------------------------------------------------
    def mailbox_list
      begin
        @imap = WmailImapUtils.current_imap
        folder_list = WmailImapUtils.get_mailbox_list
        @folders_count_hash = Hash[ folder_list.map do |a|
            [a.name, @imap.status(a.name, ["UNSEEN"])["UNSEEN"]] unless a.name == "[Gmail]"
        end ]
      rescue
        respond_to do|format|
          format.html {redirect_to authenticate_wmail_accounts_path(:redirect => params),
          :alert => 'Connection Lost. Please login to your account'}
          format.js {render :js => "window.location = '" + authenticate_wmail_accounts_path(:redirect => params) + "';"}
        end
      end
    end

  end
end
