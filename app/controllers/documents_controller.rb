class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_correct_user, only: [:edit, :update, :destroy]

  def index
    documents = Document.all

    if params[:keyword].present?
      documents = documents.where("keywords ILIKE ?", "%#{params[:keyword]}%")
    end

    if params[:category].present?
      documents = documents.where(category: params[:category])
    end

    @pagy, @documents = pagy(documents)
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.user = current_user
    if @document.save
      redirect_to @document, notice: "Document uploaded successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if params[:document][:file].present?
      @document.file.purge if @document.file.attached?
    end

    if @document.update(document_params)
      redirect_to @document, notice: "Document updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_path, notice: "Document deleted"
  end

  private

  def document_params
    params.require(:document).permit(:title, :category, :keywords, :file)
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def require_correct_user
    unless current_user == @document.user
      flash[:danger] = "Unauthorized"
      redirect_to root_url
    end
  end
end
