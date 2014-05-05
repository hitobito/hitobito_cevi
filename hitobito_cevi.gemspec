$:.push File.expand_path("../lib", __FILE__)

# Maintain your wagon's version:
require "hitobito_cevi/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hitobito_cevi"
  s.version     = HitobitoCevi::VERSION
  s.authors     = ["Pascal Zumkehr"]
  s.email       = ["zumkehr@puzzle.ch"]
  s.summary     = "Cevi organization specific features"
  s.description = "Cevi organization specific features"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  #s.test_files = Dir["test/**/*"]

end
