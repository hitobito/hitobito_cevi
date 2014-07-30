# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module MemberCountHelper

  def member_counts_fields_blueprint
    fields_for('additional_member_counts[]', @group.member_counts.build,
               builder: StandardFormBuilder) do |f|
      content_tag(:tr) do
        content_tag(:td, f.input_field(:born_in, class: 'span1')) +
        content_tag(:td, f.input_field(:person_f, class: 'span1')) +
        content_tag(:td, f.input_field(:person_m, class: 'span1'))
      end
    end
  end

  def format_member_count_born_in(member_count)
    member_count.born_in || 'unbekannt'
  end

end
