class CustomText < BaseClass
  include PublicActivity::Common

  belongs_to :enterprise

  def self.keys
    @keys ||= I18n.t('.')[:custom_text].keys
  end

  self.keys.each do |field|
    define_method("#{ field }_text") do
      return self.send(field) if self.send(field).present?

      I18n.t("custom_text.#{ field }")
    end
  end
end
