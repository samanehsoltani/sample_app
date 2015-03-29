class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # without ajax call we can use: redirect_to user
    #In the case of an Ajax request, Rails automatically calls a JavaScript
    # embedded Ruby (.js.erb) file with the same name as the action, i.e., create.js.erb or destroy.js.erb.
    # Such files allow us to mix JavaScript and embedded Ruby to perform actions
    # on the current page
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    #redirect_to user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
