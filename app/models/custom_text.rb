class CustomText < ActiveRecord::Base
  belongs_to :enterprise

  ["erg"].each do |field|
    define_method("#{ field }_text") do
      self.send(field) || I18n.t("custom_text.#{ field }")
    end
  end
end
