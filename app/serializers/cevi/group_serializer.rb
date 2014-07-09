module Cevi::GroupSerializer
  extend ActiveSupport::Concern

  included do
    extension(:attrs) do |_|
      map_properties :founding_date
    end
  end

end