$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "knock_once/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "knock_once"
  s.version     = KnockOnce::VERSION
  s.authors     = ["Nicholas Shirley"]
  s.email       = ["nicholas@reallymy.email"]
  s.homepage    = "https://github.com/nicholasshirley/knock_once"
  s.summary     = "A basic API user authorization engine built on knock."
  s.description = "knock_once provides basic user email auth using knock."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"
  s.add_dependency "knock", "~> 2.1"

  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "pg", "~> 0.21"
  s.add_development_dependency 'rspec-rails', "~> 3"
  s.add_development_dependency 'database_cleaner', "~> 1.6"
  s.add_development_dependency 'factory_bot_rails', "~> 4"
end
