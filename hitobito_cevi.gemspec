# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

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
