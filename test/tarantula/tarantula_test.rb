# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'test_helper'
require 'relevance/tarantula'
require 'tarantula/tarantula_config'

class TarantulaTest < ActionDispatch::IntegrationTest
  # Load enough test data to ensure that there's a link to every page in your
  # application. Doing so allows Tarantula to follow those links and crawl
  # every page.  For many applications, you can load a decent data set by
  # loading all fixtures.

  reset_fixture_path File.expand_path('../../../spec/fixtures', __FILE__)

  include TarantulaConfig

  def test_tarantula_as_bundesleitung
    crawl_as(people(:bulei))
  end

  def test_tarantula_as_abteilungsleiter
    crawl_as(people(:al_zh10))
  end

  def test_tarantula_as_child
    crawl_as(people(:child))
  end

  private

  def configure_urls_with_cevi(t, person)
    configure_urls_without_cevi(t, person)

    # The parent entry may already have been deleted, thus producing 404s.
    t.allow_404_for(/groups\/\d+\/member_counts$/)
  end
  alias_method_chain :configure_urls, :cevi

end
