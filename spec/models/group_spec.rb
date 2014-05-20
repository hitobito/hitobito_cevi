require 'spec_helper'

describe Group do
  include_examples 'group types'

  describe '#all_types' do
    subject { Group.all_types }

    it 'is in hierarchical order' do
      expect(subject.collect(&:name)).to eq(
        [Group::Dachverband,
         Group::Mitgliederorganisation,
         Group::Sektion,
         Group::Ortsgruppe,
         Group::Jungschar,
         Group::JungscharExterne,
         Group::Froeschli,
         Group::Stufe,
         Group::Gruppe,
         Group::JungscharTeam,
         Group::Verein,
         Group::VereinVorstand,
         Group::VereinMitglieder,
         Group::VereinExterne,
         Group::TenSing,
         Group::TenSingTeamGruppe,
         Group::TenSingExterne,
         Group::Sport,
         Group::SportTeamGruppe,
         Group::SportExterne,
         Group::WeitereArbeitsgebiete,
         Group::WeitereArbeitsgebieteExterne,
         Group::WeitereArbeitsgebieteTeamGruppe,
         Group::DachverbandVorstand,
         Group::DachverbandGeschaeftsstelle,
         Group::DachverbandGremium,
         Group::DachverbandMitglieder,
         Group::DachverbandExterne
        ].collect(&:name))
    end
  end


end
