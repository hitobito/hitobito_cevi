# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Group::CensusGroup
  extend ActiveSupport::Concern

  included do
    has_many :member_counts, foreign_key: 'group_id'
  end

  def mitgliederorganisation
    ancestors.where(type: Group::Mitgliederorganisation.sti_name).first
  end

  def census_total(year)
    MemberCount.total_for_group(year, self)
  end

  def census_details(year)
    MemberCount.details_for_group(year, self)
  end
end
