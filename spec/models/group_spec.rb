# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

describe Group do
  include_examples 'group types'

  describe '#all_types' do
    subject { Group.all_types }

    it 'is in hierarchical order' do
      expect(subject.collect(&:name)).to eq(
        [Group::Dachverband,
         Group::DachverbandVorstand,
         Group::DachverbandGeschaeftsstelle,
         Group::DachverbandGremium,
         Group::DachverbandMitglieder,
         Group::DachverbandExterne,
         Group::DachverbandSpender,
         Group::Mitgliederorganisation,
         Group::MitgliederorganisationVorstand,
         Group::MitgliederorganisationGeschaeftsstelle,
         Group::MitgliederorganisationGremium,
         Group::MitgliederorganisationMitglieder,
         Group::MitgliederorganisationExterne,
         Group::MitgliederorganisationSpender,
         Group::Sektion,
         Group::Ortsgruppe,
         Group::Jungschar,
         Group::JungscharExterne,
         Group::Froeschli,
         Group::Stufe,
         Group::Gruppe,
         Group::JungscharTeam,
         Group::JungscharSpender,
         Group::Verein,
         Group::VereinVorstand,
         Group::VereinMitglieder,
         Group::VereinExterne,
         Group::VereinSpender,
         Group::TenSing,
         Group::TenSingTeamGruppe,
         Group::TenSingExterne,
         Group::TenSingSpender,
         Group::Sport,
         Group::SportTeamGruppe,
         Group::SportExterne,
         Group::SportSpender,
         Group::WeitereArbeitsgebiete,
         Group::WeitereArbeitsgebieteExterne,
         Group::WeitereArbeitsgebieteTeamGruppe,
         Group::WeitereArbeitsgebieteSpender,
        ].collect(&:name))
    end
  end


end
