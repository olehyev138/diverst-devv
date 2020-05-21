module CustomTextHelpers
  def c_t(type)
    @custom_text ||= self.enterprise.custom_text rescue CustomText.new

    @custom_text.send("#{ type }_text")
  end
end
