#-----------------------------------------------------------------------------
# desc: Controller for mailboxes. It will hold the data and actions related to
#  inbox, sent_mails, drafts and other mailboxes.
# created on: 22/08/2012
#-----------------------------------------------------------------------------

require 'mail'

module Wmail

  class MailboxesController < ApplicationController

    before_filter :check_imap
    before_filter :mailbox_list

    #-------------------------------------------------------------------
    # desc: generalize the mail box means it will fetch all types of mails
    # from the any folders
    # params: id
    # output: html, js
    #-------------------------------------------------------------------
    def messages
      
      begin
        selected_label = params[:label].blank? ? 'INBOX' : params[:label]

        unless selected_label.blank?
          @imap = WmailImapUtils.current_imap
          @imap.select(selected_label)
          @status = @imap.status(selected_label, ['MESSAGES', 'RECENT', 'UNSEEN'])
          max = @status['MESSAGES']
          min = @status['MESSAGES']-10
          @max = 10
          @min = 1
          @mailbox = selected_label
          @inbox = []

          min = 1 if (max <= 10 and max > 0)

          @inbox = @imap.fetch(min..max, 'ENVELOPE')
          @unseen_flags = @imap.search(['NOT','SEEN'])
          @imap.expunge
        end

        session[:selected_label] = selected_label
        
        respond_to do|format|
          format.html
          format.js
        end

      rescue

        respond_to do|format|
          format.html {redirect_to login_wmail_accounts_path,
          :alert => 'Connection Lost. Please login to your account'}
          format.js
        end
        
      end
      
    end

    #-------------------------------------------------------------------
    # desc: gets the given number of mails from the given mailbox and
    #   return it to ajax call.
    # output: js
    #-------------------------------------------------------------------
    def mails

      begin
        @imap = WmailImapUtils.current_imap
        
        if not @imap.blank?
          @mailbox = params['mailbox']
          @min = params['min'].to_i
          @max = params['max'].to_i
          @total = params['total'].to_i

          @imap.select(@mailbox)
          @mails = @imap.fetch(@total-@max..@total-@min, 'ENVELOPE')
          @unseen_flags = @imap.search(['NOT','SEEN'])
        end
      rescue
        redirect_to login_wmail_accounts_path,
          :alert => 'Connection Lost. Please login to your account'
      end
    end    

  end

end
