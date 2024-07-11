#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::EventsController
  extend ActiveSupport::Concern

  included do
    before_render_form :application_contacts

    before_save :set_application_contact
  end

  private

  def set_application_contact
    if entry.class.attr_used?(:application_contact_id)
      if model_params[:application_contact_id].blank? || application_contacts.count == 1
        entry.application_contact = application_contacts.first
      end
    end
  end

  def application_contacts
    if entry.class.attr_used?(:application_contact_id)
      @application_contacts ||= entry.possible_contact_groups
    end
  end
end
