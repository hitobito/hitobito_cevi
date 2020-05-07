# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class AdditionalEventParticipationColumns < ActiveRecord::Migration[4.2]
  def change
    add_column(:event_participations, :internal_comment, :text)
    add_column(:event_participations, :payed, :boolean)
  end
end
