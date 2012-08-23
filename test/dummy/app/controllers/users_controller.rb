class UsersController < ApplicationController

  # showing login
  def index
    @user = User.new
  end

  # signin process
  def signin
    @user = User.find_by_user_name(params[:user][:user_name])

    unless @user.blank?
      sign_in @user
      # redirect_to
    else
      render "index"
    end
  end

  # showing registration
  def new
    @user = User.new
  end

  # make registration process
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to users_path
    else
      render "new"
    end

  end

  # make logout
  def destroy
  
  end
  
end