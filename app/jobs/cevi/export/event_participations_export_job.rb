#  Copyright (c) 2017, Pfadibewegung Schweiz. This file is part of
#  hitobito_youth and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_youth.

module Cevi::Export::EventParticipationsExportJob
  private

  def exporter
    if @options[:details] && ability.can?(:update, entries.build)
      Export::Tabular::People::ParticipationsComplete
    else
      super
    end
  end
end
