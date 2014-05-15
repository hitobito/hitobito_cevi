class CensusEvaluation::DachverbandController < CensusEvaluation::BaseController

  self.sub_group_type = Group::Mitgliederorganisation

  def index
    super

    respond_to do |format|
      format.html do
        @groups = group_confirmation_ratios if evaluation.current_census_year?
      end
    end
  end

  private

  def group_confirmation_ratios
    @sub_groups.inject({}) do |hash, mitgliederorganisation|
      hash[mitgliederorganisation.id] = { confirmed: number_of_confirmations(mitgliederorganisation),
                                          total: number_of_groups(mitgliederorganisation) }
      hash
    end
  end

  def number_of_confirmations(mitgliederorganisation)
    MemberCount.where(mitgliederorganisation_id: mitgliederorganisation.id, year: year).
                distinct.
                count(:group_id)
  end

  def number_of_groups(mitgliederorganisation)
    mitgliederorganisation.descendants.without_deleted.where(type: MemberCounter::TOP_LEVEL.map(&:sti_name)).count
  end

end
