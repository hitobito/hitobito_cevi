module Export::Csv::People
  class ParticipationsComplete < ParticipationsFull

    self.row_class = Export::Csv::People::ParticipationRowComplete

    def build_attribute_labels
      super.merge(custom_labels)
    end

    private

    def custom_labels
      { payed: ::Event::Participation.human_attribute_name(:payed),
        internal_comment: ::Event::Participation.human_attribute_name(:internal_comment) }
    end
  end
end
