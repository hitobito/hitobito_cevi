class Group::Verein < Group

  self.layer = true

  children Group::VereinVorstand,
           Group::VereinMitglieder,
           Group::VereinExterne

end
