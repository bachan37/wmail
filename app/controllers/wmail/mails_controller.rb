#-----------------------------------------------------------------------------
# desc: Controller for mails. It will hold the data and actions related to
#  mails in mailboxes.
# created on: 7/09/2012
#-----------------------------------------------------------------------------

require 'wmail_utils'
require 'mail'

module Wmail
  class MailsController < ApplicationController
    include WmailUtils
    before_filter :check_imap

    #-------------------------------------------------------------------
    # desc: gets the body and header of the mail with given sequence no
    # output: js
    #-------------------------------------------------------------------
    def show
      @seqno = params[:id].to_i
      @total = params[:total].to_i

      begin
        @imap = WmailImapUtils.current_imap
        message = @imap.fetch(@seqno, ['RFC822']).first.attr['RFC822']
        @mail = Mail.new(message)
      rescue
        respond_to do|format|
          format.html {redirect_to login_wmail_accounts_path,
          :alert => 'Connection Lost. Please login to your account'}
          format.js
        end
      end
    end
  end
end
