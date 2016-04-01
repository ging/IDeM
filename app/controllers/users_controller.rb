class UsersController < ApplicationController

  before_filter :authenticate_user!

  def show    
    @user = User.find_by_id(params[:id])
  end

  def edit
    @user = User.find_by_id(params[:id])
    return redirect_to(view_context.home_path, :alert => 'User Not Found') unless @user
  end

  def update
    #Use language as UI language when possible.
    if params["user"] and params["user"]["language"] and params["user"]["ui_language"].blank?
      if Utils.valid_locale?(params["user"]["language"]) and params["user"]["language"] != current_user.ui_language
        params["user"]["ui_language"] = params["user"]["language"]
      end
    end

    if current_user.update_attributes(params.require(:user).permit(:language, :ui_language, :tag_list))
      flash[:notice] = I18n.t("profile.edit.messages.success")
      redirect_to view_context.home_path
    else
      @user = current_user
      @user.valid?
      flash[:alert] = I18n.t("profile.edit.messages.fail", :reason => @user.errors.full_messages.to_sentence)
      render :edit
    end
  end

end
  