#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Sheet
  class CensusEvaluation < Base
    self.parent_sheet = Sheet::Group

    class Dachverband < Sheet::CensusEvaluation
    end

    class Mitgliederorganisation < Sheet::CensusEvaluation
    end

    class Jungschar < Sheet::CensusEvaluation
    end

    class Group < Sheet::CensusEvaluation
    end
  end
end
