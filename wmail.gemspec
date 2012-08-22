$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "wmail/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wmail"
  s.version     = Wmail::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Wmail."
  s.description = "TODO: Description of Wmail."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.8"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "mysql2"
end
