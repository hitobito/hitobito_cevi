# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class AddJsLabelToEventKindTranslations < ActiveRecord::Migration
  def change
    add_column(:event_kind_translations, :j_s_label, :string)
  end
end
