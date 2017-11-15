module KnockOnce
  class Configuration
    attr_accessor :user_params

    def initialize
      @user_params = [:email, :current_password, :password, :password_confirmation]
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    @configuration ||= Configuration.new
    yield configuration
  end
end
