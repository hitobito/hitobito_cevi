class Group::Gruppe < Group

  roles Group::Stufe::Gruppenleiter,
        Group::Stufe::Minigruppenleiter,
        Group::Stufe::Helfer,
        Group::Stufe::Teilnehmer

end
