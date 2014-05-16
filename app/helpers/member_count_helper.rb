module MemberCountHelper

  def member_counts_fields_blueprint
    fields_for('additional_member_counts[]', @group.member_counts.build, builder: StandardFormBuilder) do |f|
      content_tag(:tr) do
        content_tag(:td, f.input_field(:born_in, class: 'span1')) +
        content_tag(:td, f.input_field(:person_f, class: 'span1')) +
        content_tag(:td, f.input_field(:person_m, class: 'span1'))
      end
    end
  end
end
