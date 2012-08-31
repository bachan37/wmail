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
      wmutils = WmailImapUtils.new(:user_email => params[:user][:email],
        :user_password => params[:user][:password])

      #login to email account
      xyz = wmutils.imap_authenticate(params[:user][:email], params[:user][:password])
      puts xyz.to_s + '1st'
      x = WmailImapUtils.is_connected?
      puts x.to_s
    end

  end

end