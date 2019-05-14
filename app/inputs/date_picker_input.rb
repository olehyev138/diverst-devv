class DatePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
    value = @builder.object.send(attribute_name)
    input_html_options[:value] = case value
                                 when Date, Time, DateTime
                                   format = options[:format] || :medium
                                   value.to_s(format)
                                 else
                                   value.to_s
    end

    input_html_options[:class] ||= []
    input_html_options[:class] << 'field__input date_picker_input'
    @builder.text_field(attribute_name, input_html_options)
  end
end
