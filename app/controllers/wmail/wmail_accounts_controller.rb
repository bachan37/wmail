#-------------------------------------------------------------------
# desc: controller for the accounts
# created on: 22/08/2012
#-------------------------------------------------------------------
require 'wmail_utils'

module Wmail

  class WmailAccountsController < ApplicationController
    include WmailUtils

    #-------------------------------------------------------------------
    # desc: here we will list the accounts associated with the user.
    # output: html
    #-------------------------------------------------------------------
    def index
      if current_user.blank?
        redirect_to main_app.root_url, :notice => 'Please login first!'
      else
        @wmail_accounts = WmailAccount.find_all_by_user_id(current_user.id)
      end
    end

    #-----------------------------------------------------------------------
    # desc: here we will create a new account/ user can setup a new account
    # output: html
    #-----------------------------------------------------------------------
    def new
      @wmail_account = WmailAccount.new(:user_id => current_user.id)
    end

    #-----------------------------------------------------------------------
    # desc: Here we will process the setup the new account
    # output: NA
    #-----------------------------------------------------------------------
    def create
      if current_user
        params[:wmail_account][:user_id] = current_user.id
        @wmail_account = WmailAccount.new(params[:wmail_account])

        if @wmail_account.save
          redirect_to wmail_accounts_path, :notice => 'Account successfully added!'
        else
          flash[:alert] = 'There was some error while adding your account. Please check if the data is correct'
          render :new
        end
      else
        redirect_to main_app.root_path, :notice => 'Please login first!'
      end
    end

    #-----------------------------------------------------------------------
    # desc: just for the startup. need to move this in different controller later.
    # output: NA
    #-----------------------------------------------------------------------
    def login

    end

    #-----------------------------------------------------------------------
    # desc: just for the startup. need to move this in different controller later.
    # output: NA
    #-----------------------------------------------------------------------
    def authenticate
      account = WmailAccount.find_by_user_id_and_default(current_user.id, true)

      if account.blank?
        redirect_to new_wmail_account_path, :notice => 'Please set up an account before continuing!'
      else

        wmutils = WmailImapUtils.new(account)

        #login to email account
        wmutils.imap_authenticate(account)

        if params[:redirect].blank?
          redirect_to messages_mailboxes_path
        else
          redirect_to params[:redirect]
        end
      end
    end

  end

end