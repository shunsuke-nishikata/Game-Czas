class HomesController < ApplicationController
  # ログインしているユーザーのみに与えられる権限をスキップする処理TOPページのため
  skip_before_action :authenticate_user!

  def top
  end
end
