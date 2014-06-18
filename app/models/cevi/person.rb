

module Cevi::Person
  extend ActiveSupport::Concern

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

    if value
      I18n.t("activerecord.attributes.person.#{key.to_s.pluralize}.#{value}")
    end
  end
end
