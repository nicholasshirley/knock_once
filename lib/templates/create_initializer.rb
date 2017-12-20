KnockOnce.configure do |config|

  # WHITELIST USER PARAMS

  # By default knock_once will whitelist :user, :email, :current_password
  # :password, :password_confirmation
  # To add your own params push them into the user_param array. Example:
  # config.user_params.push(:user_name)

  # PASSWORD RESET OPTIONS

  # Reset token validity
  # By default password tokens will only be valid for one hour.
  # config.password_token_expiry = 1.hour.from_now

  # Reset token length
  # By default the reset token length is 18
  # config.reset_token_length = 18

  # REQUIRE PASSWORD FOR UPDATES

  # The three states supported for requiring passoword changes are:
  #   :all (requires current_password for password and user changes)
  #   :password (only requires current_password for password changes)
  #   :none or any other value (doesn't require current_password for any changes)
  # :all is set by default
  # config.require_password_to_change = :all

end
