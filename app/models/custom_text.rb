class CustomText < ActiveRecord::Base
  belongs_to :enterprise

  ["erg", "program"].each do |field|
    define_method("#{ field }_text") do
      return self.send(field) unless self.send(field).blank?
      I18n.t("custom_text.#{ field }")
    end
  end
end
