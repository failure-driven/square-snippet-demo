class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorise_admin, only: %i[index show admin_generator]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(account_params)
      flash[:info] = "Account successfully updated"
      redirect_to edit_account_path(params[:id])
    else
      flash[:error] = "error"
      render "edit"
    end
  end

  def admin_generator
    @user = User.find(params[:id])
    if @user.update(user_actions: { "admin" => { "can_administer" => true } })
      flash[:success] = "Account successfully updated"
      redirect_to accounts_path
    else
      flash[:error] = "error"
      redirect_to account_path(@user)
    end
  end

  def admin_revoker
    @user = User.find(params[:id])
    if @user.update(user_actions: nil)
      flash[:success] = "Account successfully updated"
      redirect_to accounts_path
    else
      flash[:error] = "error"
      redirect_to account_path(@user)
    end
  end

  private

  def account_params
    params.fetch(:user, {}).permit(:avatar)
  end
end
