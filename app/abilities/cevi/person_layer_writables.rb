# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonLayerWritables
  extend ActiveSupport::Concern

  include Cevi::PersonFetchables

  included do
    alias_method_chain :writable_conditions, :unconfined_below
  end

  private

  def writable_conditions_with_unconfined_below
    writable_conditions_without_unconfined_below.tap do |condition|
      unconfined_from_above_condition(condition)
    end
  end

end
