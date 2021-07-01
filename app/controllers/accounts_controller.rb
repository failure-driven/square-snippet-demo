class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorise_admin, only: %i[index show promote_admin revoke_admin]
  before_action :set_user, only: %i[show edit update promote_admin revoke_admin]

  def index
    @users = User.all.order(:email)
  end

  def show; end

  def edit; end

  def update
    if @user.update(account_params)
      redirect_to edit_account_path(params[:id]), notice: "Account successfully updated"
    else
      render :edit, status: :unprocessable_entity, alert: @user.errors.full_messages.inspect
    end
  end

  def promote_admin
    if @user.update(user_actions: { "admin" => { "can_administer" => true } })
      redirect_to accounts_path, notice: "Account successfully given admin priveledges"
    else
      redirect_to account_path(@user), alert: @user.errors.full_messages.inspect
    end
  end

  def revoke_admin
    if @user.update(user_actions: nil)
      redirect_to accounts_path, notice: "Account successfully revoked admin priveledges"
    else
      redirect_to account_path(@user), alert: @user.errors.full_messages.inspect
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def account_params
    params.fetch(:user, {}).permit(:avatar)
  end
end
