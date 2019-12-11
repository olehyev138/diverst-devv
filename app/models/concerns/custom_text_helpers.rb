module CustomTextHelpers
  def c_t(type, enterprise = self.try(:enterprise) || self)
    custom_text ||= enterprise.custom_text rescue CustomText.new

    custom_text.send("#{ type }_text")
  end
end
