class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # ログイン済みのユーザーにのみ権限を与える
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
  end

  # ログイン後にイベントの一覧ページに遷移する
  def after_sign_in_path_for(resource)
    events_path
  end

  def after_sign_up_path_for(resource)
    events_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
