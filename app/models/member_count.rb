#
class MemberCount < ActiveRecord::Base

  COUNT_CATEGORIES = [:person]
  COUNT_COLUMNS = COUNT_CATEGORIES.collect { |c| [:"#{c}_f", :"#{c}_m"] }.flatten

  belongs_to :group
  belongs_to :mitgliederorganisation, class_name: 'Group::Mitgliederorganisation'

  validates :year, uniqueness: { scope: :group_id }
  validates(*COUNT_COLUMNS,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true })


  def total
    f + m
  end

  def f
    sum_columns(COUNT_CATEGORIES, 'f')
  end

  def m
    sum_columns(COUNT_CATEGORIES, 'm')
  end

  COUNT_CATEGORIES.each do |c|
    define_method c do
      send("#{c}_f").to_i + send("#{c}_m").to_i
    end
  end

  private

  def sum_columns(columns, gender)
    columns.inject(0) do |sum, c|
      sum + send("#{c}_#{gender}").to_i
    end
  end

  class << self

    def total_by_mitgliederorganisationen(year)
      totals_by(year, :mitgliederorganisation_id)
    end

    def total_by_groups(year, mitgliederorganisation)
      # TODO: handle group_id/group_type
      totals_by(year, :group_id, mitgliederorganisation_id: mitgliederorganisation.id)
    end

    def total_for_dachverband(year)
      totals_by(year, :year).first
    end

    def total_for_group(year, group)
      # TODO: handle group_id/group_type
      totals_by(year, :group_id, group: group).first
    end

    def totals(year)
      # TODO: handle group_id/group_type
      columns = 'mitgliederorganisation_id, ' \
                'group_id, ' +
                COUNT_COLUMNS.collect { |c| "SUM(#{c}) AS #{c}" }.join(',')

      select(columns).where(year: year)
    end

    private

    def totals_by(year, group_by, conditions = {})
      totals(year).where(conditions).group(group_by)
    end

  end

end
