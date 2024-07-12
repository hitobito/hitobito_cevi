#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

namespace :app do
  namespace :license do
    task :config do
      @licenser = Licenser.new("hitobito_cevi",
        "CEVI Regionalverband ZH-SH-GL",
        "https://github.com/hitobito/hitobito_cevi")
    end
  end
end
