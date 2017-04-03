# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Export::Tabular
  class MemberCount < Base
    self.row_class = Row

    attr_reader :years

    def initialize(list)
      @list = grouped(list.includes(:group, :mitgliederorganisation))
      @years = list.pluck(:born_in).uniq.reject(&:blank?).sort + [:unknown]
    end

    def attributes
      attributes = [:year, :name, :address, :town, :zip_code, :mitgliederorganisation,
                    :m_total, :f_total]

      years.each_with_object(attributes) do |year|
        attributes << "m_#{year}".to_sym
        attributes << "f_#{year}".to_sym
      end
    end

    private

    def grouped(list)
      list.
        group_by(&:group_id).
        map do |_group_id, member_counts|
          common_attrs = build_common_attrs(member_counts.first)
          OpenStruct.new(add_counts(common_attrs, member_counts))
        end.
        sort_by { |s| s.name }
    end

    def build_common_attrs(reference)
      { year: reference.year,
        name: reference.group.to_s,
        address: reference.group.address,
        town: reference.group.town,
        zip_code: reference.group.zip_code,
        mitgliederorganisation: reference.mitgliederorganisation.to_s,
        m_total: 0,
        f_total: 0 }
    end

    def build_address_information(contactable)
      town_and_zip = [contactable.zip_code, contactable.town].compact.join(' ')
      [contactable.address, town_and_zip].compact.join(', ')
    end

    def add_counts(attrs, member_counts)
      member_counts.each_with_object(attrs) do |count, memo|
        year_or_unknown = count.born_in.present? ? count.born_in : :unknown
        add_count(memo, year_or_unknown, count.person_m.to_i, count.person_f.to_i)
      end
    end

    def add_count(attrs, year_or_unknown, count_m, count_f)
      attrs[:m_total] += count_m
      attrs[:f_total] += count_f

      attrs["m_#{year_or_unknown}".to_sym] = count_m
      attrs["f_#{year_or_unknown}".to_sym] = count_f
    end

    def human_attribute(attr)
      case attr
      when :name, :address, :town, :zip_code then Group.human_attribute_name(attr)
      when :mitgliederorganisation then Group::Mitgliederorganisation.model_name.human
      when :year then Census.human_attribute_name(:year)
      when /(m|f)_(\w+)/
        [translate_prefix(Regexp.last_match[2]), Regexp.last_match[1].tr('f', 'w')].join(' ')
      else fail "unknown attr: #{attr}"
      end
    end

    def translate_prefix(prefix)
      case prefix
      when /unknown/ then 'Jahrgang unbekannt'
      when /total/ then 'Total Mitglieder'
      else prefix
      end
    end
  end

end
