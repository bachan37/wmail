#-----------------------------------------------------------------------------
# desc: Controller for mailboxes. It will hold the data and actions related to
#  inbox, sent_mails, drafts and other mailboxes.
# created on: 22/08/2012
#-----------------------------------------------------------------------------

require 'wmail_utils'

module Wmail

  class MailboxesController < ApplicationController
    include WmailUtils

    before_filter :check_imap
    before_filter :mailbox_list

    #-------------------------------------------------------------------
    # desc: gets the inbox related data and passes away to view
    # output: html
    #-------------------------------------------------------------------
    def index

      if not @imap.blank?
        @imap.select('INBOX')

        @status = @imap.status('INBOX', ['MESSAGES', 'RECENT', 'UNSEEN'])
        max = @status['MESSAGES']
        min = @status['MESSAGES']-10
        @inbox = @imap.fetch(min..max, 'ENVELOPE')
        folder_list = WmailImapUtils.get_mailbox_list
        @folders_count_hash = Hash[ folder_list.map do |a|
            [a.name, @imap.status(a.name, ["UNSEEN"])["UNSEEN"]] unless a.name == "[Gmail]"
        end ]
      end
    end

    #-------------------------------------------------------------------
    # desc: gets the inbox related data and passes away to view
    # output: html
    #-------------------------------------------------------------------
    def sent_mail

      if not @imp.blank?
        @imap.select('[Gmail]/Sent Mail')

        @status = @imap.status('[Gmail]/Sent Mail', ['MESSAGES', 'RECENT', 'UNSEEN'])
        max = @status['MESSAGES']
        min = @status['MESSAGES']-10
        
        @sent_mails = @imap.fetch(min..max, 'ENVELOPE')
      end
    end

    #-------------------------------------------------------------------
    # desc: gets the given number of mails from the given mailbox and
    #   return it to ajax call.
    # output: js
    #-------------------------------------------------------------------
    def mails

      if not @imap.blank?
        @mailbox = params['mailbox']
        @min = params['min'].to_i
        @max = params['max'].to_i
        @total = params['total'].to_i

        @imap.select(@mailbox)
        @mails = @imap.fetch(@total-@max..@total-@min, 'ENVELOPE')
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
      puts WmailImapUtils.current_imap.to_s + '##############'
      puts WmailImapUtils.set_connection.to_s
      
      #redirect to login account if not connected
      if not WmailImapUtils.set_connection
        redirect_to login_wmail_accounts_path,
          :alert => 'Please login to your account'
      else
        @imap = WmailImapUtils.current_imap
        puts '**************'+@imap.disconnected?.to_s
        puts '#########'+@imap.select('INBOX').inspect
        if @imap.blank? or @imap.disconnected?
          WmailImapUtils.reconnect
          @imap = WmailImapUtils.current_imap
        end
      end

    end

  end

end
