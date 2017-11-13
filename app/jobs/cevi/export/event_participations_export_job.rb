# encoding: utf-8

#  Copyright (c) 2017, Pfadibewegung Schweiz. This file is part of
#  hitobito_youth and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_youth.

module Cevi::Export::EventParticipationsExportJob
  extend ActiveSupport::Concern

  included do
    alias_method_chain :exporter, :check
  end

  private

  def exporter_with_check
    if @controller_params[:details] && Ability.new(user).can?(:update, entries.first)
      Export::Tabular::People::ParticipationsComplete
    else
      exporter_without_check
    end
  end
end
