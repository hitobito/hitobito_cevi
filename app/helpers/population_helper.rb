#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module PopulationHelper
  BADGE_INVALID = '<span class="text-error">Angabe fehlt</span>'.html_safe

  def person_gender_with_check(person)
    if person.gender.blank?
      BADGE_INVALID
    else
      person.gender_label
    end
  end

  def person_birthday_with_check(person)
    if person.birthday.present?
      l(person.birthday)
    end
  end

  def tab_population_label(group)
    label = t("groups.tabs.population")
    label << " <span style=\"color: red;\">!</span>" if check_approveable?(group)
    label.html_safe
  end

  def check_approveable?(group)
    group.population_approveable? && can?(:create_member_counts, group)
  end
end
