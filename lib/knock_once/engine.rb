require 'knock'

module KnockOnce
  class Engine < ::Rails::Engine
    isolate_namespace KnockOnce
    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
