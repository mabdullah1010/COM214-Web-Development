class CommentsController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_document, only: %i[new create]
  before_action :require_correct_user, only: %i[edit update destroy]

  def index
    @comments = Comment.all
  end

  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.document_id = @document.id
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @document, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy!
    respond_to do |format|
      format.html { redirect_to @comment.document, status: :see_other, notice: "Comment deleted." }
      format.json { head :no_content }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_document
    @document = Document.find(params[:document_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :document_id)
  end

  def require_correct_user
    unless current_user == @comment.user
      flash[:danger] = "Unauthorized"
      redirect_to root_url
    end
  end
end
