class AuthenticationConstraint
  def self.matches?(request)
    user_id = request.env['action_dispatch.request.unsigned_session_cookie']['user_id']
    user_id
  end
end
