module Helpers
# Define headers for valid requests
  def authenticated_header
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    { 'Authorization': "Bearer #{token}" }
  end

  def bad_header
    { 'Authorization': 'Bearer AABBCC' }
  end

  def correct_password
    { email: 'newtest@test.com', current_password: user.password }
  end

  def incorrect_password
    { email: 'newtest@test.com', current_password: 'abc123' }
  end
end
