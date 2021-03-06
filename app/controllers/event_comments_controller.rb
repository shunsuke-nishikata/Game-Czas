class EventCommentsController < ApplicationController
  def create
    # イベントのID取得
    event = Event.find(params[:event_id])
    @event_comments = event.event_comments
    # コメントしたユーザーのIDとコメント内容を取得
    comment = current_user.event_comments.new(event_comment_params)
    # イベントIDを代入※空のインスタンスを作成した後に行う
    comment.event_id = event.id
    if comment.save
      event.create_notification_comment(current_user, comment.id)
    else
      flash[:notice] = "コメントを入力してください"
      redirect_to event_path(event.id)
    end
  end

  def destroy
    # 削除対象→どのイベントのどのコメントか
    # コメントのIDとイベントのIDを取得
    event = Event.find(params[:event_id])
    @event_comments = event.event_comments
    @event_comment = EventComment.find_by(id: params[:id], event_id: params[:event_id])
    @event_comment.destroy

    # イベントのIDをparamsで取得
    # redirect_to event_path(params[:event_id])
  end

  private

  def event_comment_params
    params.require(:event_comment).permit(:comment)
  end
end
