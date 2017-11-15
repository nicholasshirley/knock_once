module KnockOnce
  class Configuration
    attr_accessor :user_params

    def initialize
      @user_params = [:email, :current_password, :password, :password_confirmation]
    end
  end

  def self.configure
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
