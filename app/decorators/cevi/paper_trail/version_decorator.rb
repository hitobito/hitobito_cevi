# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PaperTrail::VersionDecorator
  extend ActiveSupport::Concern

  included do
    alias_method_chain :normalize, :ortsgruppe
  end

  private

  def normalize_with_ortsgruppe(attr, value)
    if attr == 'ortsgruppe_id'
      group = Group::Ortsgruppe.with_deleted.where(id: value).first
      group ? h.h(group.short_name || group.name) : value
    else
      normalize_without_ortsgruppe(attr, value)
    end
  end

end
