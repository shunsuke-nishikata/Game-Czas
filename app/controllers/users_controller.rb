class UsersController < ApplicationController
  
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  
  def index
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    @user.update(user_params)
    redirect_to user_path(current_user.id)
  end
  
  def favorite_events
    @user = current_user
    # 自分が作成していないイベント全て
    @events = Event.where.not(user_id: current_user.id)
  end
  
  def matching
    @users = current_user.matching
  end
  
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  
  def ensure_correct_user
    @user = User.find(params[:id])
    if current_user.id != @user.id
      redirect_back(fallback_location: root_path)
    end
  end
  
  
  def user_params
    params.require(:user).permit(:image,:name,:sex,:age,:favorite_game,:introduction,:twitter,:instagram,:youtube)
  end
end
