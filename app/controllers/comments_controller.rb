class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { render "tickets/show" }
        format.js
      else
        format.html { render "tickets/show" }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :ticket_id)
  end
end
