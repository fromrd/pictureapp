class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_action :current_user, only: [:new, :edit, :show, :destroy, :index]
  before_action :log_in, only: [:new, :edit, :show, :destroy]
  
  def top
  end
  
  def index
    @pictures = Picture.all
  end

  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end
    
  def create
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id
    if @picture.save
      ContactMailer.contact_mail(@picture).deliver
      redirect_to pictures_path, notice: '新規作成しました！'
    else
      render 'new'
    end
  end
  
  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end
  
  def edit
    @picture.image.cache! unless @picture.image.blank?
  end
  
  def update
    if @picture.update(picture_params)
      redirect_to pictures_path, notice:'編集しました！'
    else
      render 'edit'
    end
  end
  
  def destroy
    @picture.destroy
      redirect_to pictures_path, notice:'削除しました！'
  end
  
  def confirm
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id
    render 'new'if @picture.invalid?
  end
  
  def log_in
    if @current_user.nil?
      redirect_to new_session_path
    end
  end  
    
  private
  
    def picture_params
      params.require(:picture).permit(:content, :image, :image_cache)
    end
    
    def set_picture
      @picture = Picture.find(params[:id])
    end
end