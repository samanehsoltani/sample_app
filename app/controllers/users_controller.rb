class UsersController < ApplicationController

  def show #manually added
    @user = User.find(params[:id])
    #debugger  -->Rails server shows a byebug prompt which can be treated like a Rails console
  end

  def new #generated (empty) by rails generate controller Users new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save #save the user and return true if it's successfully added
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # equivalent to redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  private
  #returns an appropriate initialization hash
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

end
