class CensusEvaluation::DachverbandController < CensusEvaluation::BaseController

  # self.sub_group_type = Group::Mitgliederorganisation

  def index
    super

    respond_to do |format|
      format.html do
        @abteilungen = abteilung_confirmation_ratios if evaluation.current_census_year?
      end
    end
  end

  private

  def abteilung_confirmation_ratios
    @sub_groups.inject({}) do |hash, kantonalverband|
      hash[kantonalverband.id] = { confirmed: number_of_confirmations(kantonalverband),
                                   total: number_of_abteilungen(kantonalverband) }
      hash
    end
  end

  def number_of_confirmations(kantonalverband)
    MemberCount.where(kantonalverband_id: kantonalverband.id, year: year).
                distinct.
                count(:abteilung_id)
  end

  def number_of_abteilungen(kantonalverband)
    kantonalverband.descendants.without_deleted.where(type: Group::Abteilung.sti_name).count
  end

end
