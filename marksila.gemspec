$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "marksila/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "marksila"
  s.version     = Marksila::VERSION
  s.authors     = ["Berlimioz"]
  s.email       = ["berlimioz@gmail.com"]
  s.homepage    = "https://github.com/Berlimioz/marksila"
  s.summary     = "A Markdownify Simple Language"
  s.description = "A Markdownify Simple Language used in the Mipise project."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "sqlite3"
end
