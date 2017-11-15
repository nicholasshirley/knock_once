# module KnockOnce
#   class Configuration
#     attr_accessor :user_params

#     def initialize
#       @user_params = [:email, :current_password, :password, :password_confirmation]
#     end
#   end

#   class << self
#     attr_accessor :configuration
#   end

#   def self.configure
#     @configuration ||= Configuration.new
#     yield configuration
#   end
# end

module KnockOnce
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    mattr_accessor :user_params

    def initialize
      @user_params = [:email, :current_password, :password, :password_confirmation]
    end

    def self.user_params
      @user_params
    end
  end
end
