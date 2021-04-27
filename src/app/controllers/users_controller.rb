class UsersController < ApplicationController

  def index
    if params[:sort_by] and params[:order]
      render json: User.all.order("#{params[:sort_by]} #{params[:order]}")
    else
      render json: User.all
    end
  end

  def show
    render json: User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user
    else
      render :json => { :errors => @user.errors.full_messages }, :status => 422
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user
    else
      render :json => { :errors => @user.errors.full_messages }, :status => 422
    end
  end

  private
    def user_params
      params.require(:user).permit(:fname, :lname, :ysalary)
    end

end
