#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module CensusEvaluationHelper
  EMPTY_COUNT_VALUE = "-"

  def census_evaluation_path(group, options = {})
    klass = group.respond_to?(:klass) ? group.klass : group.class
    send(:"census_#{klass.model_name.element}_group_path", group, options)
  end

  def censuses_tab_path(*)
    censuses_path
  end

  def count_field(group, field, group_counts)
    if (count = group_counts[group.id])
      count_value(count.send(field))
    else
      EMPTY_COUNT_VALUE
    end
  end

  def count_value(value)
    (value.to_i > 0) ? value : EMPTY_COUNT_VALUE
  end
end
