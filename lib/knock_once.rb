require "knock_once/engine"

module KnockOnce
  class Configuration
    attr_accessor   :user_params,
                    :password_token_expiry,
                    :password_token_expiry,
                    :reset_token_length,
                    :require_password_to_change

    def initialize
      @user_params = :user, :email, :current_password, :password, :password_confirmation
      @password_token_expiry = 1.hour.from_now
      @reset_token_length = 18
      @require_password_to_change = :all
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
