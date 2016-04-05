module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def login(user)
    post "/users/sign_in/", 'user[email]' => user.email, 'user[password]' => user.password
  end

  def logout
    delete "/users/sign_out"
  end
end