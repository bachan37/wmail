#-----------------------------------------------------------------------------
# desc: Controller for mailboxes. It will hold the data and actions related to
#  inbox, sent_mails, drafts and other mailboxes.
# created on: 22/08/2012
#-----------------------------------------------------------------------------

require 'wmail_utils'

module Wmail

  class MailboxesController < ApplicationController
    include WmailUtils
    include MailboxHelper

    before_filter :check_imap
    before_filter :mailbox_list

    #-------------------------------------------------------------------
    # desc: gets the inbox related data and passes away to view
    # output: html
    #-------------------------------------------------------------------
    def index
      #first_label = @folders_count_hash.first[0].to_s
      #session[:selected_label] = first_label
      #redirect_to "/wmail/mailboxes/messages?label=#{first_label}"
    end

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
          @imap.select(selected_label)
          @status = @imap.status(selected_label, ['MESSAGES', 'RECENT', 'UNSEEN'])
          max = @status['MESSAGES']
          min = @status['MESSAGES']-10
          @max = 10
          @min = 0
          @mailbox = selected_label
          @inbox = []

          if max > 10
            @inbox = @imap.fetch(min..max, 'ENVELOPE')
          elsif (max <= 10 and max > 0)
            @inbox = @imap.fetch(1..max, 'ENVELOPE')
          end

          @imap.expunge
        end

        respond_to do|format|
          format.html {session[:selected_label] = selected_label}
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
    # desc: gets the inbox related data and passes away to view
    # output: html
    #-------------------------------------------------------------------
    def sent_mail

      begin
        if not @imap.blank?
          @imap.select('[Gmail]/Sent Mail')

          @status = @imap.status('[Gmail]/Sent Mail', ['MESSAGES', 'RECENT', 'UNSEEN'])
          max = @status['MESSAGES']
          min = @status['MESSAGES']-10

          @sent_mails = @imap.fetch(min..max, 'ENVELOPE')
        end
      rescue
        redirect_to login_wmail_accounts_path,
          :alert => 'Connection Lost. Please login to your account'
      end
    end

    #-------------------------------------------------------------------
    # desc: gets the given number of mails from the given mailbox and
    #   return it to ajax call.
    # output: js
    #-------------------------------------------------------------------
    def mails

      begin
        if not @imap.blank?
          @mailbox = params['mailbox']
          @min = params['min'].to_i
          @max = params['max'].to_i
          @total = params['total'].to_i

          @imap.select(@mailbox)
          @mails = @imap.fetch(@total-@max..@total-@min, 'ENVELOPE')
        end
      rescue
        redirect_to login_wmail_accounts_path,
          :alert => 'Connection Lost. Please login to your account'
      end
    end

    private

    #-------------------------------------------------------------------
    # desc: fetch the labels/folders of the mailbox
    #-------------------------------------------------------------------
    def mailbox_list
      folder_list = WmailImapUtils.get_mailbox_list
      @folders_count_hash = Hash[ folder_list.map do |a|
          [a.name, @imap.status(a.name, ["UNSEEN"])["UNSEEN"]] unless a.name == "[Gmail]"
      end ]
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
      end

      @imap = WmailImapUtils.current_imap
    end

  end

end
