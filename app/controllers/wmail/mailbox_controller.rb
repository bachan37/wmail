require 'wmail_utils'

module Wmail

  class MailboxController < ApplicationController
    before_filter :check_imap
    before_filter :mailbox_list



    private

    #-------------------------------------------------------------------
    # desc: fetch the labels/folders of the mailbox
    #-------------------------------------------------------------------
    def mailbox_list
      
    end

    #-------------------------------------------------------------------
    # desc: checking the imap object (nil, connected ot not etc.)
    #-------------------------------------------------------------------
    def check_imap

      unless WmailImapUtils.is_connected?
      
      end

    end

  end

end
