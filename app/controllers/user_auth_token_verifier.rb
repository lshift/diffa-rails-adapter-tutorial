module UserAuthTokenVerifier
  def verify_user_auth_token 
    current_user = User.find(params[:user_id]).tap { |u| pp user: u }
    token = params[:authToken] || request.env['HTTP_X_AUTHTOKEN']
    unless current_user.correct_token? token
      render status: :unauthorized, text: "Unauthorized"
    end
  end


  def self.included controller
    controller.before_filter :verify_user_auth_token
  end
end
