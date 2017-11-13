require 'knock'

module KnockOnce
  class Engine < ::Rails::Engine
    isolate_namespace KnockOnce
    config.generators.api_only = true
  end
end
