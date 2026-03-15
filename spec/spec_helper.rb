#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

load File.expand_path("../../app_root.rb", __FILE__)
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require File.join(ENV["APP_ROOT"], "spec", "spec_helper.rb")

# Fix sign_in compatibility with Devise 5.x (which removed the deprecated positional
# scope arg). Hitobito core's spec_helper prepends an anonymous module that calls
# super(resource, nil, scope: scope), which breaks Devise 5.x. We find that anonymous
# module and redefine its method to use the new keyword-only signature.
hitobito_prepend = Devise::Test::ControllerHelpers.ancestors.find do |mod|
  !mod.name && mod.instance_methods(false).include?(:sign_in)
end
hitobito_prepend&.class_eval do
  def sign_in(resource, scope: nil, confirm: true)
    resource.confirm if confirm
    super(resource, scope: scope)
  end
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[HitobitoCevi::Wagon.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.fixture_paths = [File.expand_path("../fixtures", __FILE__)]
end

TESTYEAR = 2012
