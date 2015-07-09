# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

# == Schema Information
#
# Table name: people
#
#  id                      :integer          not null, primary key
#  first_name              :string(255)
#  last_name               :string(255)
#  company_name            :string(255)
#  nickname                :string(255)
#  company                 :boolean          default(FALSE), not null
#  email                   :string(255)
#  address                 :string(1024)
#  zip_code                :integer
#  town                    :string(255)
#  country                 :string(255)
#  gender                  :string(1)
#  birthday                :date
#  additional_information  :text
#  contact_data_visible    :boolean          default(FALSE), not null
#  created_at              :datetime
#  updated_at              :datetime
#  encrypted_password      :string(255)
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  picture                 :string(255)
#  last_label_format_id    :integer
#  creator_id              :integer
#  updater_id              :integer
#  primary_group_id        :integer
#  failed_attempts         :integer          default(0)
#  locked_at               :datetime
#  title                   :string(255)
#  profession              :string(255)
#  j_s_number              :integer
#  joined                  :date
#  ahv_number              :string(255)
#  ahv_number_old          :string(255)
#  nationality             :string(255)
#  salutation_parents      :string(255)
#  name_parents            :string(255)
#  member_card_number      :integer
#  salutation              :string(255)
#  canton                  :string(255)
#  confession              :string(255)
#  correspondence_language :string(255)
#



module Cevi::Person
  extend ActiveSupport::Concern

  def canton
    self[:canton] || super
  end

  def canton_value
    value_from_i18n(:canton)
  end

  def confession_value
    value_from_i18n(:confession)
  end

  def correspondence_language_value
    value_from_i18n(:correspondence_language)
  end

  def salutation_value
    value_from_i18n(:salutation)
  end

  private

  def value_from_i18n(key)
    value = send(key)

    if value.present?
      I18n.t("activerecord.attributes.person.#{key.to_s.pluralize}.#{value}")
    end
  end
end
