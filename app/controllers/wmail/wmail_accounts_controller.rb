#-------------------------------------------------------------------
# desc: controller for the accounts
# created on: 22/08/2012
#-------------------------------------------------------------------

module Wmail

  class WmailAccountsController < ApplicationController

    #-------------------------------------------------------------------
    # desc: here we will list the accounts associated with the user.
    # output: html
    #-------------------------------------------------------------------
    def index
      @wmail_accounts = WmailAccount.find_all_by_user_id(current_user.id)
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
      
    end

  end

end
