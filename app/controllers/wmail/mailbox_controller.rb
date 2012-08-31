#-----------------------------------------------------------------------------
# desc: Controller for mailboxes. It will hold the data and actions related to
#  inbox, sent_mails, drafts and other mailboxes.
# created on: 22/08/2012
#-----------------------------------------------------------------------------

require 'wmail_utils'

module Wmail

  class MailboxController < ApplicationController
    include WmailUtils

    before_filter :check_imap
    before_filter :mailbox_list

    #-------------------------------------------------------------------
    # desc: gets the inbox related data and passes away to view
    # output: html
    #-------------------------------------------------------------------
    def index
      @imap = WmailImapUtils.current_imap

      if not @imap.blank?
        @imap.select('INBOX')

        @status = @imap.status('INBOX', ['MESSAGES', 'RECENT', 'UNSEEN'])
        max = @status['MESSAGES']
        min = @status['MESSAGES']-10
        @inbox = @imap.fetch(min..max, 'ENVELOPE')
      else
        WmailImapUtils.reconnect
      end
    end

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
