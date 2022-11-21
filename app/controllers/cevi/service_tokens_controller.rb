
module Cevi::ServiceTokensController
  extend ActiveSupport::Concern

  def permitted_attrs
    permitted = self.class.permitted_attrs
    permitted << :show_donors if can?(:show_donors, group)
    permitted
  end

end
