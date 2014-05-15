module Group::CensusGroup
  extend ActiveSupport::Concern

  included do
    has_many :member_counts, foreign_key: 'group_id'
  end

  def mitgliederorganisation
    ancestors.where(type: Group::Mitgliederorganisation.sti_name).first
  end

  def census_total(year)
    MemberCount.total_for_group(year, self)
  end
end
