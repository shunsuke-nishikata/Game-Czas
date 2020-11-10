class EventCommentsController < ApplicationController
  
  def create
    # イベントのID取得
    event = Event.find(params[:event_id])
    # コメントしたユーザーのIDとコメント内容を取得
    comment = current_user.event_comments.new(event_comment_params)
    # イベントIDを代入※空のインスタンスを作成した後に行う
    comment.event_id = event.id
    comment.save
    redirect_to event_path(event.id)
  end
  
  def destroy
    # 削除対象→どのイベントのどのコメントか
    # コメントのIDとイベントのIDを取得
    comment = EventComment.find_by(id: params[:id], event_id: params[:event_id])
    comment.destroy
    # イベントのIDをparamsで取得
    redirect_to event_path(params[:event_id])
  end
  
  private
  
  def event_comment_params
    params.require(:event_comment).permit(:comment)
  end
end
