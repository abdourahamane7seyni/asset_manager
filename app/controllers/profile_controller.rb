class ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if current_user.update_with_password(user_params)
      bypass_sign_in(current_user)
      redirect_to profile_path, notice: "Profil mis à jour avec succès."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
