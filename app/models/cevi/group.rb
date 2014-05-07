module Cevi::Group
  extend ActiveSupport::Concern

  included do
    root_types Group::Dachverband
  end
end
