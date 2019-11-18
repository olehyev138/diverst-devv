class CustomText < ApplicationRecord
  include PublicActivity::Common

  belongs_to :enterprise

  validates_length_of :privacy_statement, maximum: 191
  validates_length_of :sub_erg, maximum: 191
  validates_length_of :parent, maximum: 191
  validates_length_of :member_preference, maximum: 191
  validates_length_of :dci_abbreviation, maximum: 191
  validates_length_of :dci_full_title, maximum: 191
  validates_length_of :segment, maximum: 191
  validates_length_of :badge, maximum: 191
  validates_length_of :outcome, maximum: 191
  validates_length_of :structure, maximum: 191
  validates_length_of :program, maximum: 191
  validates_length_of :erg, maximum: 191

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
