# frozen_string_literal: true

# Copyright (c) 2021, Cevi. This file is part of
# hitobito_pbs and licensed under the Affero General Public License version 3
# or later. See the COPYING file at the top-level directory or at
# https://github.com/hitobito/hitobito_cevi.

class ProlongJSLagerleiterQualifications2021 < ActiveRecord::Migration[6.0]

  # Previously it was forgotten that in the NDS, the Lagerleiter qualifications are tied to
  # the J+S-Leiter qualifications. In hitobito, these are separate qualifications, so they
  # each need to be prolonged separately.

  QUALIFICATION_KIND_LABELS =
    ['J+S-Lagerleiter/-in LS/T'].freeze

  PROLONGED_DATE = Date.new(2022, 12, 31).freeze

  def up
    js_quali_courses_2021.find_each do |c|
      participant_ids = c.participations.where(qualified: true).collect(&:person_id)
      qualis = Qualification.where(person_id: participant_ids,
                                   qualification_kind_id:
                                   qualification_kind_ids,
                                   start_at: c.qualification_date)
      qualis.update_all(finish_at: PROLONGED_DATE)
    end
  end

  private

  def js_quali_courses_2021
    Event::Course
      .joins(:dates)
      .joins(:kind)
      .includes(:participations)
      .between(Date.new(2019, 1, 1), Date.new(2019, 12, 31))
      .where(event_kinds: { id: js_event_kind_ids })
  end

  def js_event_kind_ids
    Event::KindQualificationKind
      .where(qualification_kind_id: qualification_kind_ids, role: 'participant')
      .pluck(:event_kind_id)
  end

  def qualification_kind_ids
    @qualification_kind_ids ||=
      QualificationKind
      .where(label: QUALIFICATION_KIND_LABELS)
      .pluck(:id)
  end

end
