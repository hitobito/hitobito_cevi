# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi
  module Event
    module ParticipationsController
      extend ActiveSupport::Concern

      included do
        sort_mappings_with_indifferent_access['ortsgruppe'] =
          if ::Event.connection.adapter_name.downcase =~ /mysql/
            'CONCAT_WS("", groups.short_name, groups.name)'
          else
            '(IFNULL(groups.short_name, "") || groups.name)'
          end

        alias_method_chain :assign_attributes, :check
        alias_method_chain :tabular_exporter, :check
      end

      private

      def tabular_exporter_with_check
        if params[:details] && check?
          ::Export::Tabular::People::ParticipationsComplete
        else
          tabular_exporter_without_check
        end
      end

      # only roles with update permission are allowed to set those attributes
      def assign_attributes_with_check
        if model_params.present? && check?
          entry.payed = model_params.delete(:payed)
          entry.internal_comment = model_params.delete(:internal_comment)
        end

        assign_attributes_without_check
      end

      def check?
        can?(:update, entry.event)
      end
    end
  end
end
