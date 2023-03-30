# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

Census.seed(:year,
  {
    year: 2020,
    start_at: Date.new(2020,1,1),
    finish_at: Date.new(2020,12,31)
  },
  {
    year: 2021,
    start_at: Date.new(2021,1,1),
    finish_at: Date.new(2021,12,31)
  },
  {
    year: 2022,
    start_at: Date.new(2022,1,1),
    finish_at: Date.new(2022,12,31)
  }
)

unless MemberCount.exists?
  counted_group_models = [Group::Jungschar, Group::TenSing, Group::Sport,
                          Group::WeitereArbeitsgebiete]

  counted_group_models.each do |model|
    model.find_each do |group|
      MemberCounter.new(2020, group).count!
      MemberCounter.new(2021, group).count!
      MemberCounter.new(2022, group).count!
    end
  end
end
