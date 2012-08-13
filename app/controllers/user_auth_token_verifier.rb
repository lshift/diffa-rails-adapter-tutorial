module UserAuthTokenVerifier
  def verify_user_auth_token 
    current_user = User.find(params[:user_id]).tap { |u| pp user: u }
    unless current_user.correct_token? params[:authToken]
      render status: :unauthorized, text: "Unauthorized"
    end
  end


  def self.included controller
    controller.before_filter :verify_user_auth_token
  end
end
