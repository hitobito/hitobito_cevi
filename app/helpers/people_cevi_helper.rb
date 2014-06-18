# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module PeopleCeviHelper

  def format_correspondence_language(person)
    format_from_settings_hash(:correspondence_languages,
                              person.correspondence_language)
  end

  def format_canton(person)
    format_from_settings_hash(:cantons, person.canton)
  end

  def format_confession(person)
    format_from_settings_hash(:confessions, person.confession) || 'Keine Angabe'
  end

  private

  def format_from_settings_hash(value, key)
    if value
      Settings.application.send(value).to_hash.with_indifferent_access[key]
    end
  end
end
