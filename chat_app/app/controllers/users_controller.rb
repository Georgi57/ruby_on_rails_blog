class UsersController < ApplicationController

  before_filter :logged_in_user,  only: [:index, :show, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def new
	@user = User.new
  end
  def show
	@user = User.find(params[:id])
  end
  def create
    @user = User.new(params[:user])
    if @user.save
	  login @user
	  flash[:success] = "Welcome! You are registered."
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      login @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  private

    def logged_in_user
      unless logged_in?
        store_location
        redirect_to login_url, notice: "Please sign in."
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

	def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
