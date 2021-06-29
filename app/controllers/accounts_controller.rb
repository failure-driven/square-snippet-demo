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
    flash[:success] = "YOLO"
    redirect_to accounts_path
  end

  private

  def account_params
    params.fetch(:user, {}).permit(:avatar)
  end
end
