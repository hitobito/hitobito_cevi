# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi
  module Export
    module Tabular
      module People
        module PersonRow

          extend ActiveSupport::Concern

          def canton
            entry.canton_label
          end

          def confession
            entry.confession_label
          end

          def salutation
            entry.salutation_label
          end

          def ortsgruppe_id
            entry.ortsgruppe_label
          end

        end
      end
    end
  end
end
