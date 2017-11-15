module KnockOnce
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :user_params

    def initialize
      @user_params = [:email, :current_password, :password, :password_confirmation]
    end

    def self.user_params
      user_params
    end
  end
end
