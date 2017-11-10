$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "knock_once/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "knock_once"
  s.version     = KnockOnce::VERSION
  s.authors     = ["Nicholas Shirley"]
  s.email       = ["nicholas@reallymy.email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of KnockOnce."
  s.description = "TODO: Description of KnockOnce."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pg"
end
