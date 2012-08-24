class UsersController < ApplicationController

  before_filter :is_signed_in, :only => [:home, :signout]
  before_filter :is_signed_out, :only => [:index, :signin, :new]

  # showing login
  def index
    @user = User.new
  end

  # signin process
  def signin
    @user = User.find_by_user_name(params[:user][:user_name])

    unless @user.blank?
      sign_in @user
      redirect_to home_users_path
    else
      render "index"
    end
  end

  def home
    
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
  def signout
    sign_out
    redirect_to users_path
  end

  private

  def is_signed_in
    redirect_to users_path if current_user.blank?
  end

  def is_signed_out
    redirect_to home_users_path unless current_user.blank?
  end


end
