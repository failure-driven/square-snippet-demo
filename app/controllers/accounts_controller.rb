class AccountsController < ApplicationController
  def index
    # TODO admin list with pagy
  end

  def show
    # TODO admin acces ?
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

  private

  def account_params
    params.fetch(:user, {}).permit(:avatar)
  end
end
