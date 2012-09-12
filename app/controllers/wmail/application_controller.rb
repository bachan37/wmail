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
          format.html {redirect_to login_wmail_accounts_path,
          :alert => 'Connection Lost. Please login to your account'}
          format.js {render :js => "window.location = '" + login_wmail_accounts_path + "';"}
        end
      end
    end

  end
end
