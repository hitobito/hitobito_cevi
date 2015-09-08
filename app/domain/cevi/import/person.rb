# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Import::Person
  extend ActiveSupport::Concern

  included do
    class << self
      alias_method_chain :relevant_attributes, :ortsgruppe_removed
    end
  end

  module ClassMethods
    def relevant_attributes_with_ortsgruppe_removed
      relevant_attributes_without_ortsgruppe_removed - %w(ortsgruppe_id)
    end
  end
end
