module AuthHelper
  def self.authenticated_user
    user = User.find_by_email('admin@gmail.com')

    if user.nil?
      user = User.create(name: 'Administrator', email: 'admin@gmail.com', password: 'solomon', password_confirmation: 'solomon')
    end

    token = JsonWebToken.encode(user_id: user.id)
    {
      id: user.id,
      auth_header: { 'Authorization': "Bearer #{token}" }
    }
  end
end
