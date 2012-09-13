class User < ActiveRecord::Base
  def correct_token? token
    (token == self.auth_token) and not self.auth_token.empty?
  end
end
