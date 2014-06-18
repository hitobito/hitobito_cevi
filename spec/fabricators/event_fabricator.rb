# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

Fabricator(:cevi_course, from: :course) do
  application_contact do |attrs|

    contact_groups = []
    groups = attrs[:groups]
    groups.each do |g|
      if type = g.class.contact_group_type
        state_agencies = g.children.without_deleted.where(type: type.sti_name)
        contact_groups.concat(state_agencies)
      end
    end
    contact_groups.sample

  end
end
